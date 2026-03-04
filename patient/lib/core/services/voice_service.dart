import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  static VoiceService get instance => _instance;

  VoiceService._internal();

  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _isInitialized = false;
  bool _isSttAvailable = false;
  bool _isDisposed = false;
  
  final StreamController<String> _speechController = StreamController<String>.broadcast();
  final StreamController<bool> _listeningController = StreamController<bool>.broadcast();
  final StreamController<bool> _speakingController = StreamController<bool>.broadcast();

  Stream<String> get speechStream => _speechController.stream;
  Stream<bool> get listeningStream => _listeningController.stream;
  Stream<bool> get speakingStream => _speakingController.stream;

  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;

  void _emitListening(bool value) {
    if (!_isDisposed && !_listeningController.isClosed) {
      _listeningController.add(value);
    }
  }

  void _emitSpeaking(bool value) {
    if (!_isDisposed && !_speakingController.isClosed) {
      _speakingController.add(value);
    }
  }

  void _emitSpeech(String value) {
    if (!_isDisposed && !_speechController.isClosed) {
      _speechController.add(value);
    }
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _isSttAvailable = await _speechToText.initialize(
        onError: (error) {
          debugPrint('Speech to Text Error: $error');
          _isListening = false;
          _emitListening(_isListening);
        },
        onStatus: (status) {
          debugPrint('Speech to Text Status: $status');
          if (status == 'done' || status == 'notListening') {
            _isListening = false;
            _emitListening(_isListening);
          }
        },
      );

      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      
      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
        _emitSpeaking(_isSpeaking);
      });
      
      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        _emitSpeaking(_isSpeaking);
      });
      
      _flutterTts.setErrorHandler((message) {
        debugPrint('TTS Error: $message');
        _isSpeaking = false;
        _emitSpeaking(_isSpeaking);
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint('Voice Service initialization error: $e');
    }
  }

  Future<bool> startListening() async {
    if (!_isInitialized) await initialize();
    
    if (_isListening) return false;
    if (!_isSttAvailable) return false;
    
    try {
      
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            _emitSpeech(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: "en_US",
        onSoundLevelChange: (level) {
          // Optional: Handle sound level changes
        },
      );
      
      _isListening = true;
      _emitListening(_isListening);
      return true;
    } catch (e) {
      debugPrint('Start listening error: $e');
      return false;
    }
  }

  Future<void> stopListening() async {
    if (!_isListening) return;
    
    await _speechToText.stop();
    _isListening = false;
    _emitListening(_isListening);
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) await initialize();
    
    if (_isSpeaking) {
      await _flutterTts.stop();
    }
    
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('Speak error: $e');
    }
  }

  Future<void> stopSpeaking() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
    }
  }

  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    await _speechToText.stop();
    await _flutterTts.stop();
    await _speechController.close();
    await _listeningController.close();
    await _speakingController.close();
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/fetures/categories/manager/cancelRequest/cancel_request_cubit.dart';
import 'dart:math';
import 'dart:async';
import 'dart:convert';

import 'package:sehetna/fetures/categories/view/Request_Accepted_view.dart';
import 'package:sehetna/generated/l10n.dart';
import 'package:shimmer/shimmer.dart'; // Added for JSON parsing

class ServiceWaitingView extends StatefulWidget {
  final String requestId;
  final String customerId;

  const ServiceWaitingView({
    super.key,
    required this.requestId,
    required this.customerId,
  });

  @override
  State<ServiceWaitingView> createState() => _ServiceWaitingViewState();
}

class _ServiceWaitingViewState extends State<ServiceWaitingView>
    with SingleTickerProviderStateMixin {
  // Main color variables
  static Color mainColor = kPrimaryColor;
  static Color darkMainColor = kSecondaryColor;
  static const Color lightMainColor = Color(0xFF7EBFE6);
  static const Color backgroundColor = Color(0xFF0A1E3C);

  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconRotationAnimation;
  late Timer _typingTimer;
  String _displayText = '';
  int _charIndex = 0;
  bool _isDeleting = false;
  final String _fullText = 'Please Wait...';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<DocumentSnapshot> _requestStream;
  bool _isDisposed = false;

  // Flag to track if navigation has been initiated
  bool _navigationInitiated = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 INIT ServiceWaitingView for request: ${widget.requestId}');

    // Initialize Firestore stream
    final docPath =
        'customer_requests/${widget.customerId}/updates/accepted_${widget.requestId}';
    debugPrint('🔥 Firestore path: $docPath');

    _requestStream = _firestore
        .collection('customer_requests')
        .doc(widget.customerId)
        .collection('updates')
        .doc('accepted_${widget.requestId}')
        .snapshots()
        .handleError((error) {
      debugPrint('❌ Firestore error: $error');
    });

    // Animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _rotationAnimation =
        Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 0.9), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _iconRotationAnimation =
        Tween<double>(begin: 0, end: 2 * pi).animate(_controller);

    // Typing animation setup
    _typingTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (!_isDeleting) {
        if (_charIndex < _fullText.length) {
          if (!_isDisposed) {
            setState(() {
              _displayText = _fullText.substring(0, _charIndex + 1);
              _charIndex++;
            });
          }
        } else {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (!_isDisposed) {
              setState(() {
                _isDeleting = true;
              });
            }
          });
        }
      } else {
        if (_displayText.isNotEmpty) {
          if (!_isDisposed) {
            setState(() {
              _displayText = _displayText.substring(0, _displayText.length - 1);
            });
          }
        } else {
          if (!_isDisposed) {
            setState(() {
              _isDeleting = false;
              _charIndex = 0;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    debugPrint('♻️ DISPOSING ServiceWaitingView');
    _isDisposed = true;
    _controller.dispose();
    _typingTimer.cancel();
    super.dispose();
  }

  void _handleRequestAccepted(Map<String, dynamic> data) {
    debugPrint('🎯 REQUEST ACCEPTED DATA: ${data.toString()}');

    // Check if navigation has already been initiated to prevent multiple calls
    if (_navigationInitiated) {
      debugPrint('⛔ Navigation already initiated - skipping duplicate call');
      return;
    }

    if (!_isDisposed) {
      debugPrint('⏳ Scheduling navigation in 500ms...');

      try {
        // Parse the provider JSON string to Map
        final providerMap =
            json.decode(data['provider']) as Map<String, dynamic>;
        debugPrint('✅ Parsed provider data: $providerMap');

        // Set flag to prevent multiple navigations
        _navigationInitiated = true;

        Future.delayed(const Duration(milliseconds: 500), () {
          if (!_isDisposed && mounted) {
            debugPrint('➡️ NAVIGATING to RequestAcceptedView');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RequestAcceptedView(
                  providerData: providerMap,
                  serviceName: data['service_name'].toString(),
                  expectedTime: data['expected_time'].toString(),
                ),
              ),
            );
          } else {
            debugPrint('⛔ Navigation aborted - widget disposed or not mounted');
            // Reset flag if navigation was aborted
            _navigationInitiated = false;
          }
        });
      } catch (e) {
        debugPrint('❌ Error parsing provider data: $e');
        // Reset flag if there was an error
        _navigationInitiated = false;
        // Show error to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading provider data: $e')),
        );
      }
    } else {
      debugPrint('⛔ Navigation aborted - widget disposed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: _requestStream,
          builder: (context, snapshot) {
            debugPrint(
                '🔄 StreamBuilder rebuilt - Connection: ${snapshot.connectionState}');

            if (snapshot.hasError) {
              debugPrint('❌ Stream error: ${snapshot.error}');
              return _buildErrorUI(snapshot.error.toString());
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              debugPrint('⏳ Waiting for initial data...');
            }

            if (snapshot.connectionState == ConnectionState.active) {
              debugPrint('✅ Stream is active');
              if (snapshot.hasData) {
                debugPrint('📄 Snapshot has data');
                if (snapshot.data!.exists) {
                  debugPrint('📝 Document exists');
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  debugPrint('📊 Document data: ${data.toString()}');

                  if (data['status'] == 'accepted' && !_navigationInitiated) {
                    debugPrint('🟢 Accepted status detected!');
                    _handleRequestAccepted(data);
                  } else if (_navigationInitiated) {
                    debugPrint(
                        '🔄 Navigation already in progress - skip handling');
                  } else {
                    debugPrint('🟡 Unexpected status: ${data['status']}');
                  }
                } else {
                  debugPrint('📭 Document does not exist yet');
                }
              }
            }

            return _buildMainUI();
          },
        ),
      ),
    );
  }

  Widget _buildMainUI() {
    return BlocProvider(
      create: (context) => CancelRequestCubit(),
      child: BlocConsumer<CancelRequestCubit, CancelRequestState>(
        listener: (context, state) {
          if (state is CancelRequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is CancelRequestFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: ParticlePainter(
                        time: _controller.value * 2,
                        particleCount: 30,
                        particleColor: mainColor.withOpacity(0.1),
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 40,
                      child: Text(
                        _displayText,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Transform.rotate(
                                angle: _rotationAnimation.value,
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        mainColor.withOpacity(0.3),
                                        Colors.transparent,
                                      ],
                                      stops: const [0.1, 1.0],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      lightMainColor.withOpacity(0.9),
                                      mainColor.withOpacity(0.6),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: mainColor.withOpacity(0.5),
                                      blurRadius: 30,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Transform.rotate(
                                  angle: _iconRotationAnimation.value,
                                  child: const Icon(
                                    Icons.radar,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return FadingDot(
                          index: index,
                          controller: _controller,
                          dotColor: lightMainColor,
                        );
                      }),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: state is CancelRequestLoading
                          ? Shimmer.fromColors(
                              baseColor: darkMainColor.withOpacity(0.6),
                              highlightColor: darkMainColor.withOpacity(0.9),
                              child: Container(
                                height: 56, // Match your button height
                                width: 120,
                                decoration: BoxDecoration(
                                  color: darkMainColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkMainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 40),
                                elevation: 8,
                                shadowColor: mainColor.withOpacity(0.4),
                              ),
                              onPressed: () {
                                BlocProvider.of<CancelRequestCubit>(context)
                                    .cancelRequest(
                                        requestId: widget.requestId,
                                        comment: "comment");
                              },
                              child: Text(
                                S.of(context).cancel,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorUI(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 20),
          const Text(
            'Connection Error',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Reinitialize the stream
                _requestStream = _firestore
                    .collection('customer_requests')
                    .doc(widget.customerId)
                    .collection('updates')
                    .doc('accepted_${widget.requestId}')
                    .snapshots();
              });
            },
            child: const Text('Retry Connection'),
          ),
        ],
      ),
    );
  }
}

class FadingDot extends StatelessWidget {
  final int index;
  final AnimationController controller;
  final Color dotColor;

  const FadingDot({
    super.key,
    required this.index,
    required this.controller,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    final start = 0.0 + index * 0.25;
    final end = start + 0.5;

    final animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 0.5),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 0.5),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          start.clamp(0.0, 0.75),
          end.clamp(0.25, 1.0),
          curve: Curves.easeInOut,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.scale(
            scale: animation.value * 1.5,
            child: Container(
              margin: const EdgeInsets.all(8),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: dotColor.withOpacity(0.8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: dotColor.withOpacity(0.4),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double time;
  final int particleCount;
  final Color particleColor;

  ParticlePainter({
    required this.time,
    required this.particleCount,
    required this.particleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(time.floor());
    final paint = Paint()..color = particleColor;

    for (int i = 0; i < particleCount; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final radius = rnd.nextDouble() * 2 + 1;
      final progress = (time + rnd.nextDouble()) % 1;

      canvas.drawCircle(
        Offset(x, y),
        radius * (0.5 + 0.5 * sin(progress * 2 * pi)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.time != time;
  }
}

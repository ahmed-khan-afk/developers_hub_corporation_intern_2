import 'dart:ui';
import 'package:flutter/material.dart';
import 'glass_container.dart';

class AddTaskSheet extends StatefulWidget {
  final String? initialValue;
  final String title;

  const AddTaskSheet({
    super.key,
    this.initialValue,
    this.title = 'Add New Task',
  });

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _animController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  Future<void> _dismiss() async {
    await _animController.reverse();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onTap: _dismiss,
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: GestureDetector(
                        onTap: () {},
                        child: SafeArea(
                          top: false,
                          child: SingleChildScrollView(
                            reverse: true,
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 60),
                              padding: EdgeInsets.fromLTRB(
                                20,
                                24,
                                20,
                                MediaQuery.of(context).viewInsets.bottom + 30,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFF1a1635).withValues(alpha: 0.92),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(28),
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 44,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.35),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    widget.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Form(
                                    key: _formKey,
                                    child: GlassContainer(
                                      borderRadius: 14,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 4),
                                      child: TextFormField(
                                        controller: _controller,
                                        focusNode: _focusNode,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                        maxLines: 3,
                                        minLines: 1,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                          hintText: 'What do you need to do?',
                                          hintStyle: TextStyle(
                                            color:
                                                Colors.white.withValues(alpha: 0.4),
                                            fontSize: 15,
                                          ),
                                          border: InputBorder.none,
                                          errorStyle: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Task cannot be empty';
                                          }
                                          if (value.trim().length < 2) {
                                            return 'Task must be at least 2 characters';
                                          }
                                          return null;
                                        },
                                        onFieldSubmitted: (_) => _submit(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GlassContainer(
                                          borderRadius: 14,
                                          tintColor: Colors.white,
                                          opacity: 0.1,
                                          child: TextButton(
                                            onPressed: _dismiss,
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                            ),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        flex: 2,
                                        child: GlassContainer(
                                          borderRadius: 14,
                                          tintColor: const Color(0xFF7C3AED),
                                          opacity: 0.7,
                                          border: Border.all(
                                            color: const Color(0xFFa78bfa)
                                                .withValues(alpha: 0.5),
                                            width: 1.5,
                                          ),
                                          child: TextButton(
                                            onPressed: _submit,
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                            ),
                                            child: Text(
                                              widget.initialValue != null
                                                  ? 'Save Changes'
                                                  : 'Add Task',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }
}

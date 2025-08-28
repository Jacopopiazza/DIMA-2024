import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/services/image_upload_service.dart';
import 'package:flutter/material.dart';

/// A network image widget that automatically retries with a refreshed URL
/// when encountering 403 errors (typically expired S3 URLs)
class NetworkImageWithRetry extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const NetworkImageWithRetry({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<NetworkImageWithRetry> createState() => _NetworkImageWithRetryState();
}

class _NetworkImageWithRetryState extends State<NetworkImageWithRetry> {
  late String _currentUrl;
  bool _hasRetried = false;
  final ImageUploadService _imageUploadService = ImageUploadService();

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.imageUrl;
  }

  @override
  void didUpdateWidget(NetworkImageWithRetry oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl) {
      setState(() {
        _currentUrl = widget.imageUrl;
        _hasRetried = false;
      });
    }
  }

  Future<void> _handleImageError(Object error) async {
    // Check if this is a 403 error (expired URL) and we haven't retried yet
    if (!_hasRetried && error.toString().contains('403')) {
      try {
        safePrint('Image URL expired, attempting to refresh: $_currentUrl');

        final refreshedUrl =
            await _imageUploadService.refreshImageUrl(_currentUrl);
        if (refreshedUrl != null && mounted) {
          setState(() {
            _currentUrl = refreshedUrl;
            _hasRetried = true;
          });
          safePrint('Successfully refreshed image URL');
        } else {
          safePrint('Failed to refresh image URL');
        }
      } catch (e) {
        safePrint('Error refreshing image URL: $e');
      }
    } else {
      safePrint('Image loading failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Image.network(
      _currentUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return widget.placeholder ??
            Container(
              width: widget.width,
              height: widget.height,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        // Attempt to handle the error (retry with refreshed URL)
        _handleImageError(error);

        return widget.errorWidget ??
            Container(
              width: widget.width,
              height: widget.height,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _hasRetried ? Icons.broken_image : Icons.refresh,
                    size: (widget.width ?? 120) * 0.3,
                    color: _hasRetried
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _hasRetried ? 'Failed to load' : 'Retrying...',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _hasRetried
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
      },
    );
  }
}

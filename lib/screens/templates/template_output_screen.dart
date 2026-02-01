// ============================================================
//        ELITE TEMPLATE OUTPUT SCREEN
// ============================================================
//
// Displays generated content with beautiful UI and
// multiple export/share options.
//
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'template_models.dart';
import 'template_ai_service.dart';
import 'export_service.dart';

class TemplateOutputScreen extends StatefulWidget {
  final AppTemplate template;
  final TemplateOutput output;

  const TemplateOutputScreen({
    super.key,
    required this.template,
    required this.output,
  });

  @override
  State<TemplateOutputScreen> createState() => _TemplateOutputScreenState();
}

class _TemplateOutputScreenState extends State<TemplateOutputScreen>
    with SingleTickerProviderStateMixin {
  final _exportService = ExportService();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  ExportFormat _selectedFormat = ExportFormat.text;
  bool _showCopied = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String get _displayContent {
    return widget.output.getExport(_selectedFormat);
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF0A0A0A);
    const surfaceColor = Color(0xFF1A1A1A);
    final primaryColor = widget.template.gradientColors[0];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              // Header
              _buildHeader(primaryColor, surfaceColor),
              
              // Format Selector (if multiple formats available)
              if (widget.template.availableExports.length > 1)
                _buildFormatSelector(primaryColor),
              
              // Content
              Expanded(
                child: _buildContent(surfaceColor, primaryColor),
              ),
              
              // Action Buttons
              _buildActions(primaryColor, surfaceColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color primaryColor, Color surfaceColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: widget.template.gradientColors),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(widget.template.icon, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.template.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'Generated successfully',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Regenerate Button
          GestureDetector(
            onTap: () {
              // Go back to fill screen to regenerate
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.refresh, color: primaryColor, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatSelector(Color primaryColor) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: widget.template.availableExports.map((format) {
          final isSelected = format == _selectedFormat;
          return GestureDetector(
            onTap: () => setState(() => _selectedFormat = format),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor.withOpacity(0.2) : const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getFormatIcon(format),
                    size: 16,
                    color: isSelected ? primaryColor : Colors.white54,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getFormatLabel(format),
                    style: TextStyle(
                      color: isSelected ? primaryColor : Colors.white70,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getFormatIcon(ExportFormat format) {
    switch (format) {
      case ExportFormat.text: return Icons.text_fields;
      case ExportFormat.markdown: return Icons.article;
      case ExportFormat.csv: return Icons.table_chart;
      case ExportFormat.html: return Icons.code;
      case ExportFormat.json: return Icons.data_object;
      case ExportFormat.ics: return Icons.calendar_today;
    }
  }

  String _getFormatLabel(ExportFormat format) {
    switch (format) {
      case ExportFormat.text: return 'Text';
      case ExportFormat.markdown: return 'Markdown';
      case ExportFormat.csv: return 'CSV';
      case ExportFormat.html: return 'HTML';
      case ExportFormat.json: return 'JSON';
      case ExportFormat.ics: return 'Calendar';
    }
  }

  Widget _buildContent(Color surfaceColor, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Stack(
        children: [
          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: SelectableText(
              _displayContent,
              style: TextStyle(
                fontSize: _selectedFormat == ExportFormat.csv ? 13 : 16,
                color: Colors.white,
                height: 1.8,
                fontFamily: _selectedFormat == ExportFormat.csv ||
                        _selectedFormat == ExportFormat.json ||
                        _selectedFormat == ExportFormat.html
                    ? 'monospace'
                    : null,
              ),
            ),
          ),
          
          // Quick Copy Button (top right)
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: _copyToClipboard,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _showCopied ? Colors.green : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _showCopied ? Icons.check : Icons.copy,
                      size: 16,
                      color: _showCopied ? Colors.white : Colors.white70,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _showCopied ? 'Copied!' : 'Copy',
                      style: TextStyle(
                        fontSize: 12,
                        color: _showCopied ? Colors.white : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Target App Badge (if applicable)
          if (widget.template.targetApp != null)
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.open_in_new, size: 12, color: primaryColor),
                    const SizedBox(width: 6),
                    Text(
                      'Ready for ${widget.template.targetApp}',
                      style: TextStyle(
                        fontSize: 11,
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(Color primaryColor, Color surfaceColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Column(
        children: [
          // Main Action Buttons
          Row(
            children: [
              // Copy Button
              Expanded(
                child: _buildActionButton(
                  label: 'Copy',
                  icon: Icons.copy,
                  color: primaryColor,
                  isPrimary: true,
                  onTap: _copyToClipboard,
                ),
              ),
              const SizedBox(width: 12),
              // Share Button
              Expanded(
                child: _buildActionButton(
                  label: 'Share',
                  icon: Icons.share,
                  color: Colors.white,
                  isPrimary: false,
                  onTap: _shareContent,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Secondary Actions
          Row(
            children: [
              // Save as File
              Expanded(
                child: _buildActionButton(
                  label: 'Save File',
                  icon: Icons.save_alt,
                  color: Colors.white,
                  isPrimary: false,
                  onTap: _saveAsFile,
                ),
              ),
              const SizedBox(width: 12),
              // More Options
              GestureDetector(
                onTap: _showMoreOptions,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.more_horiz, color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(colors: widget.template.gradientColors)
              : null,
          color: isPrimary ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isPrimary ? Colors.white : color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : color,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard() async {
    await _exportService.copyToClipboard(_displayContent);
    setState(() => _showCopied = true);
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showCopied = false);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Copied to clipboard!'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareContent() async {
    await _exportService.shareText(
      _displayContent,
      subject: widget.template.name,
    );
  }

  void _saveAsFile() async {
    final fileName = '${widget.template.id}_${DateTime.now().millisecondsSinceEpoch}';
    
    await _exportService.shareAsFile(
      content: _displayContent,
      fileName: fileName,
      format: _selectedFormat,
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _MoreOptionsSheet(
        template: widget.template,
        output: widget.output,
        exportService: _exportService,
      ),
    );
  }
}

// ============================================================
// MORE OPTIONS BOTTOM SHEET
// ============================================================

class _MoreOptionsSheet extends StatelessWidget {
  final AppTemplate template;
  final TemplateOutput output;
  final ExportService exportService;

  const _MoreOptionsSheet({
    required this.template,
    required this.output,
    required this.exportService,
  });

  @override
  Widget build(BuildContext context) {
    final options = getExportOptions(template);
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Title
          const Text(
            'Export Options',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          // Options Grid
          ...options.map((option) => _buildOptionTile(context, option)),
          
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, ExportOption option) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pop(context);
        _executeOption(context, option);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: template.gradientColors[0].withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(option.icon, color: template.gradientColors[0], size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  if (option.targetApp != null)
                    Text(
                      'Opens in ${option.targetApp}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
          ],
        ),
      ),
    );
  }

  void _executeOption(BuildContext context, ExportOption option) async {
    final content = output.getExport(option.format);
    final fileName = '${template.id}_${DateTime.now().millisecondsSinceEpoch}';

    switch (option.format) {
      case ExportFormat.text:
        if (option.label == 'Copy') {
          await exportService.copyToClipboard(content);
        } else {
          await exportService.shareText(content, subject: template.name);
        }
        break;
      case ExportFormat.csv:
        await exportService.exportToSheets(content, fileName);
        break;
      case ExportFormat.markdown:
        await exportService.exportToNotion(content, fileName);
        break;
      case ExportFormat.ics:
        await exportService.exportToCalendar(content, fileName);
        break;
      default:
        await exportService.shareAsFile(
          content: content,
          fileName: fileName,
          format: option.format,
        );
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_page_scaffold.dart';
import 'package:re_view_front/features/banners/domain/entities/managed_banner.dart';
import 'package:re_view_front/features/banners/presentation/providers/banner_providers.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

class AdminBannersPage extends ConsumerStatefulWidget {
  const AdminBannersPage({super.key});
  @override
  ConsumerState<AdminBannersPage> createState() => _AdminBannersPageState();
}

class _AdminBannersPageState extends ConsumerState<AdminBannersPage> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _image = TextEditingController();
  final _mobileImage = TextEditingController();
  final _target = TextEditingController();
  final _order = TextEditingController(text: '0');
  String? _editingId;
  bool _active = false;
  BannerDraft? _preview;

  BannerDraft _draft() => BannerDraft(
    title: _title.text.trim(),
    imageUrl: _image.text.trim(),
    mobileImageUrl: _mobileImage.text.trim().isEmpty
        ? null
        : _mobileImage.text.trim(),
    targetUrl: _target.text.trim(),
    displayOrder: int.tryParse(_order.text) ?? -1,
    active: _active,
  );
  void _edit(ManagedBanner? banner) {
    setState(() {
      _editingId = banner?.id;
      _title.text = banner?.title ?? '';
      _image.text = banner?.imageUrl ?? '';
      _mobileImage.text = banner?.mobileImageUrl ?? '';
      _target.text = banner?.targetUrl ?? '';
      _order.text = '${banner?.displayOrder ?? 0}';
      _active = banner?.active ?? false;
      _preview = null;
    });
    _form.currentState?.reset();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final result = await ref
        .read(adminBannerViewModelProvider.notifier)
        .save(_draft(), id: _editingId);
    if (!mounted) return;
    result.when(
      success: (saved) {
        _edit(saved);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('배너를 저장했습니다.')));
      },
      failure: (f) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(f.message)));
      },
    );
  }

  @override
  void dispose() {
    for (final controller in [_title, _image, _mobileImage, _target, _order]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminBannerViewModelProvider);
    final contract = ref.watch(bannerApiContractProvider);
    final busy = state.loading || state.saving;
    final preview = _preview;
    return AdminPageScaffold(
      title: '배너 관리',
      subtitle: '홈 배너를 등록하고 노출 순서와 활성 여부를 관리합니다.',
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (contract == null)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '배너 등록 서버 연결이 준비되지 않아 저장할 수 없습니다. 입력과 미리보기는 사용할 수 있습니다. 이미지 업로드는 지원되지 않으며 공개 HTTPS 이미지 URL을 입력해주세요.',
                ),
              ),
            ),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: busy ? null : () => _edit(null),
                child: const Text('새 배너'),
              ),
              OutlinedButton(
                onPressed: busy || contract == null
                    ? null
                    : () => ref
                          .read(adminBannerViewModelProvider.notifier)
                          .loadList(),
                child: const Text('목록 새로고침'),
              ),
            ],
          ),
          if (state.loading) const LinearProgressIndicator(),
          if (state.failure != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                state.failure!.message,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          if (!state.loading && state.failure == null && state.items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('등록된 배너가 없습니다.'),
            ),
          for (final banner in state.items)
            Card(
              child: ListTile(
                title: Text(banner.title),
                subtitle: Text(
                  '순서 ${banner.displayOrder} · ${banner.active ? "활성" : "비활성"}\n${banner.targetUrl}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  tooltip: '배너 수정',
                  onPressed: busy ? null : () => _edit(banner),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ),
            ),
          const SizedBox(height: 20),
          Text(
            _editingId == null ? '배너 등록' : '배너 수정',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _title,
                  enabled: !busy,
                  maxLength: 120,
                  decoration: const InputDecoration(labelText: '제목 (관리·접근성)'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? '제목을 입력해주세요.' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _image,
                  enabled: !busy,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: '배너 이미지 URL',
                    helperText: '공개 HTTPS 이미지. 기존 배너 비율 약 2.33:1.',
                  ),
                  validator: (v) => BannerDraft.isImageUrl(v ?? '')
                      ? null
                      : '공개 HTTPS 이미지 URL을 입력해주세요.',
                ),
                if (contract?.supportsMobileImages == true) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _mobileImage,
                    enabled: !busy,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      labelText: '모바일 이미지 URL (선택)',
                    ),
                    validator: (v) =>
                        v == null ||
                            v.trim().isEmpty ||
                            BannerDraft.isImageUrl(v)
                        ? null
                        : 'HTTPS 이미지 URL을 입력해주세요.',
                  ),
                ],
                const SizedBox(height: 12),
                TextFormField(
                  controller: _target,
                  enabled: !busy,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: '클릭 대상',
                    helperText: '/search?q=… 같은 앱 경로 또는 HTTPS 주소.',
                  ),
                  validator: (v) => BannerDraft.isTargetUrl(v ?? '')
                      ? null
                      : '앱 내부 경로나 HTTPS 주소를 입력해주세요.',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _order,
                  enabled: !busy,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: '노출 순서 (작은 숫자부터)',
                  ),
                  validator: (v) {
                    final n = int.tryParse(v ?? '');
                    return n != null && n >= 0 && n <= 2147483647
                        ? null
                        : '0 이상의 유효한 순서를 입력해주세요.';
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('활성 (홈에 노출)'),
                  value: _active,
                  onChanged: busy
                      ? null
                      : (value) => setState(() => _active = value),
                ),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: busy
                          ? null
                          : () {
                              if (_form.currentState!.validate()) {
                                setState(() => _preview = _draft());
                              }
                            },
                      child: const Text('미리보기'),
                    ),
                    FilledButton(
                      onPressed: busy || contract == null ? null : _save,
                      child: Text(state.saving ? '저장 중…' : '저장'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (preview != null) ...[
            const SizedBox(height: 20),
            Text(preview.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 1916 / 821,
              child: AppNetworkImage(
                url: preview.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            if (preview.mobileImageUrl != null)
              AspectRatio(
                aspectRatio: 1916 / 821,
                child: AppNetworkImage(
                  url: preview.mobileImageUrl!,
                  fit: BoxFit.contain,
                ),
              ),
            SelectableText('클릭 대상: ${preview.targetUrl}'),
            const Text(
              '전체 이미지를 표시한 미리보기입니다. 홈에서는 기존 카드 비율에 맞춰 가장자리가 잘릴 수 있습니다.',
            ),
          ],
        ],
      ),
    );
  }
}

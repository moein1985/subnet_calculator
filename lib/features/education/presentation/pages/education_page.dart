import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

import '../../../../core/l10n/localization_extension.dart';
import '../../domain/entities/education_article.dart';
import '../../../settings/presentation/bloc/app_settings_bloc.dart';
import '../bloc/education_bloc.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.education)),
      body: BlocBuilder<EducationBloc, EducationState>(
        builder: (context, state) {
          if (state.status == EducationStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == EducationStatus.failure) {
            return Center(child: Text(l10n.comingSoon));
          }

          final languageCode = context
              .read<AppSettingsBloc>()
              .state
              .locale
              .languageCode;
          final isFa = languageCode == 'fa';
            final ipv4Articles = state.articles
              .where((article) => article.track == EducationTrack.ipv4)
              .toList();
            final ipv6Articles = state.articles
              .where((article) => article.track == EducationTrack.ipv6)
              .toList();

          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: [Tab(text: l10n.ipv4Tab), Tab(text: l10n.ipv6)],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _EducationIpv4Tab(
                        isFa: isFa,
                        languageCode: languageCode,
                        articles: ipv4Articles,
                      ),
                      _EducationIpv6Tab(
                        isFa: isFa,
                        languageCode: languageCode,
                        articles: ipv6Articles,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EducationIpv4Tab extends StatelessWidget {
  const _EducationIpv4Tab({
    required this.isFa,
    required this.languageCode,
    required this.articles,
  });

  final bool isFa;
  final String languageCode;
  final List<EducationArticle> articles;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length + 4,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index == 0) return _SchematicLearningCard(isFa: isFa);
        if (index == 1) return _PrefixComparisonCard(isFa: isFa);
        if (index == 2) return _PracticeCard(isFa: isFa);
        if (index == 3) return _MiniQuizCard(isFa: isFa);

        final article = articles[index - 4];
        return _EducationArticleTile(
          title: languageCode == 'fa' ? article.titleFa : article.titleEn,
          content:
              languageCode == 'fa' ? article.contentFa : article.contentEn,
        );
      },
    );
  }
}

class _EducationIpv6Tab extends StatelessWidget {
  const _EducationIpv6Tab({
    required this.isFa,
    required this.languageCode,
    required this.articles,
  });

  final bool isFa;
  final String languageCode;
  final List<EducationArticle> articles;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length + 1,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index == 0) return _Ipv6MiniQuizCard(isFa: isFa);

        final article = articles[index - 1];
        return _EducationArticleTile(
          title: languageCode == 'fa' ? article.titleFa : article.titleEn,
          content:
              languageCode == 'fa' ? article.contentFa : article.contentEn,
        );
      },
    );
  }
}

class _EducationArticleTile extends StatelessWidget {
  const _EducationArticleTile({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(title),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(content),
        ),
      ],
    );
  }
}

class _SchematicLearningCard extends StatefulWidget {
  const _SchematicLearningCard({required this.isFa});

  final bool isFa;

  @override
  State<_SchematicLearningCard> createState() => _SchematicLearningCardState();
}

class _SchematicLearningCardState extends State<_SchematicLearningCard> {
  double _prefix = 24;

  @override
  Widget build(BuildContext context) {
    final isFa = widget.isFa;
    final steps = isFa
        ? const ['IP', 'Mask/Prefix', 'Network', 'Broadcast', 'Host Range']
        : const ['IP', 'Mask/Prefix', 'Network', 'Broadcast', 'Host Range'];
    final networkBits = _prefix.toInt();
    final hostBits = 32 - networkBits;
    final totalHosts = math.pow(2, hostBits).toInt();
    final usableHosts = switch (networkBits) {
      32 => 1,
      31 => 2,
      _ => totalHosts - 2,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isFa ? 'نمای شماتیک محاسبه' : 'Schematic Calculation Flow',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    isFa
                        ? 'Prefix: /$networkBits - بیت شبکه: $networkBits - بیت میزبان: $hostBits'
                        : 'Prefix: /$networkBits - Network bits: $networkBits - Host bits: $hostBits',
                  ),
                ),
              ],
            ),
            Slider(
              value: _prefix,
              min: 0,
              max: 32,
              divisions: 32,
              label: '/${_prefix.toInt()}',
              onChanged: (value) {
                setState(() {
                  _prefix = value;
                });
              },
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(32, (index) {
                  final isNetworkBit = index < networkBits;
                  return Container(
                    width: 10,
                    height: 24,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: isNetworkBit
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isFa
                  ? 'بیت های آبی: بخش Network | بیت های روشن: بخش Host'
                  : 'Blue bits: Network part | Light bits: Host part',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            Text(
              isFa
                  ? 'تعداد میزبان قابل استفاده: $usableHosts'
                  : 'Usable hosts: $usableHosts',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 10),
            Text(
              isFa
                  ? 'برای درک سریع، مسیر محاسبه را مرحله به مرحله دنبال کنید.'
                  : 'Follow the calculation path step by step for faster understanding.',
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var index = 0; index < steps.length; index++) ...[
                    Chip(label: Text(steps[index])),
                    if (index < steps.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.arrow_forward, size: 18),
                      ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isFa
                    ? 'حالا با تغییر اسلایدر می توانید اثر Prefix را به صورت شماتیک ببینید.'
                    : 'Now you can see prefix impact visually by moving the slider.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniQuizCard extends StatefulWidget {
  const _MiniQuizCard({required this.isFa});

  final bool isFa;

  @override
  State<_MiniQuizCard> createState() => _MiniQuizCardState();
}

class _MiniQuizCardState extends State<_MiniQuizCard> {
  int _questionIndex = 0;
  int _score = 0;
  int? _selectedOption;
  bool _finished = false;

  List<_QuizQuestion> get _questions => [
    _QuizQuestion(
      faQuestion: 'در /24 چند بیت برای شبکه است؟',
      enQuestion: 'How many network bits are in /24?',
      faOptions: const ['8', '16', '24', '32'],
      enOptions: const ['8', '16', '24', '32'],
      correctIndex: 2,
    ),
    _QuizQuestion(
      faQuestion: 'کدام Subnet Mask برای /26 درست است؟',
      enQuestion: 'Which subnet mask matches /26?',
      faOptions: const [
        '255.255.255.0',
        '255.255.255.192',
        '255.255.0.0',
        '255.255.255.224',
      ],
      enOptions: const [
        '255.255.255.0',
        '255.255.255.192',
        '255.255.0.0',
        '255.255.255.224',
      ],
      correctIndex: 1,
    ),
    _QuizQuestion(
      faQuestion: 'در /31 چند آدرس قابل استفاده داریم؟',
      enQuestion: 'How many usable addresses are in /31?',
      faOptions: const ['0', '1', '2', '254'],
      enOptions: const ['0', '1', '2', '254'],
      correctIndex: 2,
    ),
  ];

  void _submitOrNext() {
    if (_finished) {
      setState(() {
        _questionIndex = 0;
        _score = 0;
        _selectedOption = null;
        _finished = false;
      });
      return;
    }

    if (_selectedOption == null) {
      return;
    }

    final current = _questions[_questionIndex];
    if (_selectedOption == current.correctIndex) {
      _score++;
    }

    if (_questionIndex == _questions.length - 1) {
      setState(() {
        _finished = true;
      });
      return;
    }

    setState(() {
      _questionIndex++;
      _selectedOption = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFa = widget.isFa;

    if (_finished) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFa ? 'نتیجه آزمون کوتاه' : 'Mini Quiz Result',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                isFa
                    ? 'امتیاز شما: $_score از ${_questions.length}'
                    : 'Your score: $_score / ${_questions.length}',
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _submitOrNext,
                child: Text(isFa ? 'شروع دوباره' : 'Restart Quiz'),
              ),
            ],
          ),
        ),
      );
    }

    final current = _questions[_questionIndex];
    final question = isFa ? current.faQuestion : current.enQuestion;
    final options = isFa ? current.faOptions : current.enOptions;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isFa ? 'آزمون کوتاه' : 'Mini Quiz',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isFa
                  ? 'سوال ${_questionIndex + 1} از ${_questions.length}'
                  : 'Question ${_questionIndex + 1} of ${_questions.length}',
            ),
            const SizedBox(height: 8),
            Text(question),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(options.length, (index) {
                return ChoiceChip(
                  label: Text(options[index]),
                  selected: _selectedOption == index,
                  onSelected: (_) {
                    setState(() {
                      _selectedOption = index;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _submitOrNext,
              child: Text(isFa ? 'ثبت و ادامه' : 'Submit and Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrefixComparisonCard extends StatelessWidget {
  const _PrefixComparisonCard({required this.isFa});

  final bool isFa;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isFa
                  ? 'مقایسه مستقیم /24 و /26'
                  : 'Direct Comparison: /24 vs /26',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              border: TableBorder.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  children: [
                    _TableCell(
                      text: isFa ? 'ویژگی' : 'Property',
                      isHeader: true,
                    ),
                    _TableCell(text: '/24', isHeader: true),
                    _TableCell(text: '/26', isHeader: true),
                  ],
                ),
                TableRow(
                  children: [
                    _TableCell(text: isFa ? 'Subnet Mask' : 'Subnet Mask'),
                    _TableCell(text: '255.255.255.0'),
                    _TableCell(text: '255.255.255.192'),
                  ],
                ),
                TableRow(
                  children: [
                    _TableCell(text: isFa ? 'کل آدرس ها' : 'Total Addresses'),
                    _TableCell(text: '256'),
                    _TableCell(text: '64'),
                  ],
                ),
                TableRow(
                  children: [
                    _TableCell(text: isFa ? 'قابل استفاده' : 'Usable Hosts'),
                    _TableCell(text: '254'),
                    _TableCell(text: '62'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              isFa
                  ? 'نتیجه: /26 برای شبکه های کوچک تر مناسب تر است و /24 فضای بیشتری می دهد.'
                  : 'Takeaway: /26 is better for smaller segments, while /24 gives larger host capacity.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Ipv6MiniQuizCard extends StatefulWidget {
  const _Ipv6MiniQuizCard({required this.isFa});

  final bool isFa;

  @override
  State<_Ipv6MiniQuizCard> createState() => _Ipv6MiniQuizCardState();
}

class _Ipv6MiniQuizCardState extends State<_Ipv6MiniQuizCard> {
  int _questionIndex = 0;
  int _score = 0;
  int? _selectedOption;
  bool _finished = false;

  List<_QuizQuestion> get _questions => [
    _QuizQuestion(
      faQuestion: 'کدام بازه مربوط به Link-local در IPv6 است؟',
      enQuestion: 'Which range is Link-local in IPv6?',
      faOptions: const ['2000::/3', 'fe80::/10', 'fc00::/7', 'ff00::/8'],
      enOptions: const ['2000::/3', 'fe80::/10', 'fc00::/7', 'ff00::/8'],
      correctIndex: 1,
    ),
    _QuizQuestion(
      faQuestion: 'آدرس ::1 چه نوعی است؟',
      enQuestion: 'What type is ::1?',
      faOptions: const ['Multicast', 'Unique Local', 'Loopback', 'Global'],
      enOptions: const ['Multicast', 'Unique Local', 'Loopback', 'Global'],
      correctIndex: 2,
    ),
    _QuizQuestion(
      faQuestion: 'پیشوند رایج LAN در IPv6 کدام است؟',
      enQuestion: 'What is the common LAN prefix in IPv6?',
      faOptions: const ['/48', '/56', '/64', '/96'],
      enOptions: const ['/48', '/56', '/64', '/96'],
      correctIndex: 2,
    ),
  ];

  void _submitOrNext() {
    if (_finished) {
      setState(() {
        _questionIndex = 0;
        _score = 0;
        _selectedOption = null;
        _finished = false;
      });
      return;
    }

    if (_selectedOption == null) return;

    final current = _questions[_questionIndex];
    if (_selectedOption == current.correctIndex) {
      _score++;
    }

    if (_questionIndex == _questions.length - 1) {
      setState(() {
        _finished = true;
      });
      return;
    }

    setState(() {
      _questionIndex++;
      _selectedOption = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFa = widget.isFa;

    if (_finished) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFa ? 'نتیجه آزمون کوتاه IPv6' : 'IPv6 Mini Quiz Result',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                isFa
                    ? 'امتیاز شما: $_score از ${_questions.length}'
                    : 'Your score: $_score / ${_questions.length}',
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _submitOrNext,
                child: Text(isFa ? 'شروع دوباره' : 'Restart Quiz'),
              ),
            ],
          ),
        ),
      );
    }

    final current = _questions[_questionIndex];
    final question = isFa ? current.faQuestion : current.enQuestion;
    final options = isFa ? current.faOptions : current.enOptions;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isFa ? 'آزمون کوتاه IPv6' : 'IPv6 Mini Quiz',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isFa
                  ? 'سوال ${_questionIndex + 1} از ${_questions.length}'
                  : 'Question ${_questionIndex + 1} of ${_questions.length}',
            ),
            const SizedBox(height: 8),
            Text(question),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(options.length, (index) {
                return ChoiceChip(
                  label: Text(options[index]),
                  selected: _selectedOption == index,
                  onSelected: (_) {
                    setState(() {
                      _selectedOption = index;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _submitOrNext,
              child: Text(isFa ? 'ثبت و ادامه' : 'Submit and Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PracticeCard extends StatefulWidget {
  const _PracticeCard({required this.isFa});

  final bool isFa;

  @override
  State<_PracticeCard> createState() => _PracticeCardState();
}

class _PracticeCardState extends State<_PracticeCard> {
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final isFa = widget.isFa;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isFa ? 'تمرین کوتاه با پاسخ' : 'Short Practice with Answer',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isFa
                  ? 'سوال: برای IP برابر 192.168.10.44/26، آدرس Network و Broadcast چیست؟'
                  : 'Question: For 192.168.10.44/26, what are the Network and Broadcast addresses?',
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _showAnswer = !_showAnswer;
                });
              },
              child: Text(
                _showAnswer
                    ? (isFa ? 'پنهان کردن پاسخ' : 'Hide Answer')
                    : (isFa ? 'نمایش پاسخ' : 'Show Answer'),
              ),
            ),
            if (_showAnswer) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isFa
                      ? 'پاسخ:\nNetwork: 192.168.10.0\nBroadcast: 192.168.10.63\nHost Range: 192.168.10.1 تا 192.168.10.62'
                      : 'Answer:\nNetwork: 192.168.10.0\nBroadcast: 192.168.10.63\nHost Range: 192.168.10.1 to 192.168.10.62',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({required this.text, this.isHeader = false});

  final String text;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: isHeader
            ? Theme.of(context).textTheme.labelLarge
            : Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _QuizQuestion {
  const _QuizQuestion({
    required this.faQuestion,
    required this.enQuestion,
    required this.faOptions,
    required this.enOptions,
    required this.correctIndex,
  });

  final String faQuestion;
  final String enQuestion;
  final List<String> faOptions;
  final List<String> enOptions;
  final int correctIndex;
}

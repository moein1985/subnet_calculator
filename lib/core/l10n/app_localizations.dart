import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('fa'), Locale('en')];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Subnet Calculator',
      'home': 'Subnet',
      'tools': 'Tools',
      'education': 'Education',
      'history': 'History',
      'settings': 'Settings',
      'aboutApp': 'About App',
      'aboutSummary':
          'Network calculator and educational toolkit for IPv4 and IPv6.',
      'developedBy': 'Developed by',
      'developerName': 'Moein Mohseni Fard',
        'toolsMainSection': 'Main Tools',
        'toolsMoreSection': 'More Tools',
        'toolVlsm': 'VLSM Planner',
        'toolSummarization': 'CIDR Summarization',
        'toolSplitMerge': 'Split / Merge Assistant',
        'toolShareReport': 'Share Report',
        'toolTemplates': 'Saved Templates',
        'toolIpv6PrefixPlanner': 'IPv6 Prefix Planner',
        'toolReverseDns': 'Reverse DNS Helper',
        'toolAddressInspector': 'Address Type Inspector',
        'generate': 'Generate',
        'summarize': 'Summarize',
        'split': 'Split',
        'share': 'Share',
        'remaining': 'Remaining',
        'summaryRoute': 'Summary Route',
        'inputNetworks': 'Input Networks',
        'range': 'Range',
        'routePolicyNote':
          'Note: verify merged blocks are contiguous in routing policy.',
        'baseNetworkCidr': 'Base Network (CIDR)',
        'hostNeedsCommaSeparated': 'Host Needs (comma separated)',
        'subnetListPerLine': 'Subnet list (one per line)',
        'baseCidr': 'Base CIDR',
        'splitToPrefix': 'Split to prefix',
        'reportText': 'Report text',
        'readyTemplates': 'Ready templates:',
        'basePrefix48': 'Base Prefix (/48)',
        'siteCount': 'Site count',
        'ipAddress': 'IP address',
        'generatePtr': 'Generate PTR',
        'address': 'Address',
        'inspect': 'Inspect',
        'noResultYet': 'No result yet',
        'noSubnetsAllocated': 'No subnets allocated',
        'noSplitResult': 'No split result',
        'waste': 'Waste',
        'site': 'Site',
        'ptrRecordIpv4': 'PTR record for IPv4',
        'ptrRecordIpv6': 'PTR record for IPv6',
        'addressInspectorIpv4Hint':
          'Use private ranges for internal networks and public ranges for internet-facing hosts.',
        'addressInspectorIpv6Hint':
          'Review policy before routing this type across segments.',
        'shareUnavailableCopied': 'Share unavailable, copied instead',
        'invalidVlsmInput': 'Invalid input. Example: 192.168.10.0/24 and 60,30,12',
        'invalidSummarizationInput': 'Invalid input. Provide one CIDR per line.',
        'invalidSplitInput': 'Invalid split input.',
        'invalidIpv6PlannerInput': 'Invalid input. Example: 2001:db8::/48 and 4',
        'ipv4Private': 'IPv4 Private',
        'ipv4Public': 'IPv4 Public',
        'ipv6Loopback': 'IPv6 Loopback',
        'ipv6LinkLocal': 'IPv6 Link-local',
        'ipv6UniqueLocal': 'IPv6 Unique Local',
        'ipv6Multicast': 'IPv6 Multicast',
        'ipv6GlobalOther': 'IPv6 Global/Other',
        'unknownFormat': 'Unknown format',
        'historyLabelSubnetIpv4': 'IPv4 Subnet',
        'historyLabelSubnetIpv6': 'IPv6 Subnet',
      'ipv4Address': 'IPv4 Address',
      'prefixLength': 'Prefix / Mask',
      'ipv4Tab': 'IPv4',
      'prefixMaskHint': 'Examples: 24, /24, 255.255.255.0',
      'calculate': 'Calculate',
      'ipv6': 'IPv6',
      'comingSoon': 'Coming soon',
      'analyzeIpv6': 'Analyze IPv6',
      'ipv6Input': 'IPv6 Address / Prefix',
      'ipv6InputHint': 'Examples: 2001:db8::1/64 or fe80::1',
      'invalidIpv6': 'Enter a valid IPv6 address',
      'invalidIpv6Prefix': 'Prefix must be between 0 and 128',
      'compressed': 'Compressed',
      'expanded': 'Expanded',
      'networkPrefix': 'Network Prefix',
      'firstAddress': 'First Address',
      'lastAddress': 'Last Address',
      'totalAddresses': 'Total Addresses',
      'classification': 'Classification',
      'classificationDescription': 'Description',
      'ipv4Mapped': 'IPv4-mapped',
      'yes': 'Yes',
      'no': 'No',
      'ipv6UnderstandTitle': 'IPv6 in one minute',
      'ipv6UnderstandBody':
          'IPv6 uses 128 bits, supports huge address space, and commonly uses /64 in LANs.',
      'basicMode': 'Basic',
      'advancedMode': 'Advanced',
        'basicModeEnabledHint':
          'Basic mode is active: quick and essential IPv6 output.',
        'advancedModeEnabledHint':
          'Advanced mode is active: full technical IPv6 details are shown.',
        'basicModeDetailsHint':
          'Basic mode shows a clean summary for quick subnet decisions.',
        'advancedModeDetailsHint':
          'Advanced mode shows expanded/compressed forms, bit counts, and deep details.',
      'interfaceId': 'Interface ID',
      'networkBits': 'Network Bits',
      'hostBits': 'Host Bits',
      'ipv4vsIpv6Title': 'IPv4 vs IPv6 in 5 minutes',
      'ipv4vsIpv6Body':
          'IPv4 is 32-bit with dotted decimal format. IPv6 is 128-bit with hex groups and no broadcast concept.',
      'compareField': 'Field',
      'compareIpv4': 'IPv4',
      'compareIpv6': 'IPv6',
      'addressLength': 'Address Length',
      'notation': 'Notation',
      'deliveryModel': 'Delivery Model',
      'natUsage': 'NAT Usage',
      'typePracticeTitle': 'Practice: address type',
      'typePracticeQuestion': 'fe80::12 is which IPv6 type?',
      'checkAnswer': 'Check',
      'correctAnswer': 'Correct: Link-local',
      'wrongAnswer': 'Try again. Hint: starts with fe80::/10',
      'invalidIp': 'Enter a valid IPv4 address',
      'invalidPrefix': 'Enter a valid prefix or subnet mask',
      'networkAddress': 'Network Address',
      'broadcastAddress': 'Broadcast Address',
      'subnetMask': 'Subnet Mask',
      'wildcardMask': 'Wildcard Mask',
      'firstHost': 'First Host',
      'lastHost': 'Last Host',
      'usableHosts': 'Usable Hosts',
      'copy': 'Copy',
      'copied': 'Copied',
      'language': 'Language',
      'persian': 'Persian',
      'english': 'English',
      'educationTitle': 'Network Basics',
      'historyTitle': 'Recent Calculations',
      'noHistory': 'No calculations yet',
        'clearHistory': 'Clear history',
        'clearHistoryConfirm':
          'Are you sure you want to remove all saved calculations?',
        'cancel': 'Cancel',
        'clear': 'Clear',
        'delete': 'Delete',
      'result': 'Result',
      'input': 'Input',
      'calculateSubnet': 'Calculate Subnet',
      'ipv6Hint': 'IPv6 support is under development',
        'defaultCalculatorTab': 'Default Calculator Tab',
        'privacy': 'Privacy',
        'offlinePrivacyNote':
          'This app works fully offline. No calculation data is sent to any server.',
    },
    'fa': {
      'appTitle': 'ماشین حساب سابنت',
      'home': 'سابنت',
      'tools': 'ابزارها',
      'education': 'آموزش',
      'history': 'تاریخچه',
      'settings': 'تنظیمات',
      'aboutApp': 'درباره برنامه',
      'aboutSummary': 'محاسبه گر و ابزار آموزشی شبکه برای IPv4 و IPv6.',
      'developedBy': 'توسعه دهنده',
      'developerName': 'معین محسنی فرد',
        'toolsMainSection': 'ابزارهای اصلی',
        'toolsMoreSection': 'ابزارهای بیشتر',
        'toolVlsm': 'برنامه ریز VLSM',
        'toolSummarization': 'خلاصه سازی CIDR',
        'toolSplitMerge': 'تقسیم/ادغام سابنت',
        'toolShareReport': 'اشتراک گزارش',
        'toolTemplates': 'قالب های آماده',
        'toolIpv6PrefixPlanner': 'برنامه ریز Prefix IPv6',
        'toolReverseDns': 'راهنمای Reverse DNS',
        'toolAddressInspector': 'بازرس نوع آدرس',
        'generate': 'تولید',
        'summarize': 'خلاصه سازی',
        'split': 'تقسیم',
        'share': 'اشتراک',
        'remaining': 'باقی مانده',
        'summaryRoute': 'مسیر خلاصه',
        'inputNetworks': 'تعداد شبکه های ورودی',
        'range': 'بازه',
        'routePolicyNote':
          'نکته: پیوستگی بلوک های ادغام شده را با سیاست مسیریابی بررسی کنید.',
        'baseNetworkCidr': 'شبکه مبنا (CIDR)',
        'hostNeedsCommaSeparated': 'نیاز میزبان (با ویرگول)',
        'subnetListPerLine': 'لیست سابنت (هر خط یک مورد)',
        'baseCidr': 'CIDR مبنا',
        'splitToPrefix': 'تقسیم تا پیشوند',
        'reportText': 'متن گزارش',
        'readyTemplates': 'قالب های آماده:',
        'basePrefix48': 'پیشوند مبنا (/48)',
        'siteCount': 'تعداد سایت',
        'ipAddress': 'آدرس IP',
        'generatePtr': 'تولید PTR',
        'address': 'آدرس',
        'inspect': 'بررسی',
        'noResultYet': 'هنوز نتیجه ای وجود ندارد',
        'noSubnetsAllocated': 'سابنتی تخصیص داده نشد',
        'noSplitResult': 'نتیجه ای برای تقسیم وجود ندارد',
        'waste': 'هدررفت',
        'site': 'سایت',
        'ptrRecordIpv4': 'رکورد PTR برای IPv4',
        'ptrRecordIpv6': 'رکورد PTR برای IPv6',
        'addressInspectorIpv4Hint':
          'برای شبکه داخلی از رنج خصوصی و برای میزبان های اینترنتی از رنج عمومی استفاده کنید.',
        'addressInspectorIpv6Hint':
          'قبل از مسیریابی این نوع آدرس بین سگمنت ها، سیاست شبکه را بررسی کنید.',
        'shareUnavailableCopied': 'اشتراک در دسترس نبود، نتیجه کپی شد',
        'invalidVlsmInput': 'ورودی نامعتبر است. نمونه: 192.168.10.0/24 و 60,30,12',
        'invalidSummarizationInput': 'ورودی نامعتبر است. هر CIDR را در یک خط وارد کنید.',
        'invalidSplitInput': 'ورودی تقسیم نامعتبر است.',
        'invalidIpv6PlannerInput': 'ورودی نامعتبر است. نمونه: 2001:db8::/48 و 4',
        'ipv4Private': 'IPv4 خصوصی',
        'ipv4Public': 'IPv4 عمومی',
        'ipv6Loopback': 'IPv6 لوپ بک',
        'ipv6LinkLocal': 'IPv6 لینک محلی',
        'ipv6UniqueLocal': 'IPv6 یکتای محلی',
        'ipv6Multicast': 'IPv6 چندپخشی',
        'ipv6GlobalOther': 'IPv6 عمومی/سایر',
        'unknownFormat': 'فرمت ناشناخته',
        'historyLabelSubnetIpv4': 'سابنت IPv4',
        'historyLabelSubnetIpv6': 'سابنت IPv6',
      'ipv4Address': 'آدرس IPv4',
      'prefixLength': 'پیشوند / ماسک',
      'ipv4Tab': 'IPv4',
      'prefixMaskHint': 'مثال: 24، /24، 255.255.255.0',
      'calculate': 'محاسبه',
      'ipv6': 'IPv6',
      'comingSoon': 'بزودی',
      'analyzeIpv6': 'تحلیل IPv6',
      'ipv6Input': 'آدرس IPv6 / پیشوند',
      'ipv6InputHint': 'مثال: 2001:db8::1/64 یا fe80::1',
      'invalidIpv6': 'یک آدرس IPv6 معتبر وارد کنید',
      'invalidIpv6Prefix': 'پیشوند باید بین 0 تا 128 باشد',
      'compressed': 'فرم فشرده',
      'expanded': 'فرم کامل',
      'networkPrefix': 'پیشوند شبکه',
      'firstAddress': 'اولین آدرس',
      'lastAddress': 'آخرین آدرس',
      'totalAddresses': 'تعداد کل آدرس ها',
      'classification': 'نوع آدرس',
      'classificationDescription': 'توضیح',
      'ipv4Mapped': 'IPv4-mapped',
      'yes': 'بله',
      'no': 'خیر',
      'ipv6UnderstandTitle': 'IPv6 در یک دقیقه',
      'ipv6UnderstandBody':
          'IPv6 از 128 بیت استفاده می کند، فضای آدرسی بسیار بزرگی دارد و در شبکه محلی معمولا با /64 استفاده می شود.',
      'basicMode': 'ساده',
      'advancedMode': 'پیشرفته',
        'basicModeEnabledHint':
          'حالت ساده فعال شد: خروجی های اصلی و سریع IPv6 نمایش داده می شود.',
        'advancedModeEnabledHint':
          'حالت پیشرفته فعال شد: جزئیات کامل فنی IPv6 نمایش داده می شود.',
        'basicModeDetailsHint':
          'در حالت ساده، خلاصه ای تمیز برای تصمیم گیری سریع سابنت نمایش داده می شود.',
        'advancedModeDetailsHint':
          'در حالت پیشرفته، فرم کامل/فشرده، تعداد بیت ها و جزئیات عمیق نمایش داده می شود.',
      'interfaceId': 'شناسه رابط',
      'networkBits': 'بیت های شبکه',
      'hostBits': 'بیت های میزبان',
      'ipv4vsIpv6Title': 'IPv4 vs IPv6 در 5 دقیقه',
      'ipv4vsIpv6Body':
          'IPv4 از 32 بیت با نمایش عددی نقطه دار استفاده می کند. IPv6 از 128 بیت با گروه های هگز استفاده می کند و مفهوم broadcast ندارد.',
      'compareField': 'ویژگی',
      'compareIpv4': 'IPv4',
      'compareIpv6': 'IPv6',
      'addressLength': 'طول آدرس',
      'notation': 'نمایش',
      'deliveryModel': 'مدل ارسال',
      'natUsage': 'استفاده از NAT',
      'typePracticeTitle': 'تمرین: نوع آدرس',
      'typePracticeQuestion': 'fe80::12 چه نوع آدرس IPv6 است؟',
      'checkAnswer': 'بررسی',
      'correctAnswer': 'درست است: Link-local',
      'wrongAnswer': 'دوباره تلاش کن. راهنما: با fe80::/10 شروع می شود',
      'invalidIp': 'یک آدرس IPv4 معتبر وارد کنید',
      'invalidPrefix': 'یک پیشوند یا ماسک معتبر وارد کنید',
      'networkAddress': 'آدرس شبکه',
      'broadcastAddress': 'آدرس برودکست',
      'subnetMask': 'ماسک سابنت',
      'wildcardMask': 'ماسک وایلدکارت',
      'firstHost': 'اولین میزبان',
      'lastHost': 'آخرین میزبان',
      'usableHosts': 'تعداد میزبان قابل استفاده',
      'copy': 'کپی',
      'copied': 'کپی شد',
      'language': 'زبان',
      'persian': 'فارسی',
      'english': 'انگلیسی',
      'educationTitle': 'مبانی شبکه',
      'historyTitle': 'محاسبات اخیر',
      'noHistory': 'هنوز محاسبه ای انجام نشده است',
        'clearHistory': 'پاک کردن تاریخچه',
        'clearHistoryConfirm':
          'آیا مطمئن هستید که می خواهید همه محاسبات ذخیره شده حذف شوند؟',
        'cancel': 'انصراف',
        'clear': 'پاک کردن',
        'delete': 'حذف',
      'result': 'نتیجه',
      'input': 'ورودی',
      'calculateSubnet': 'محاسبه سابنت',
      'ipv6Hint': 'پشتیبانی IPv6 در حال توسعه است',
        'defaultCalculatorTab': 'تب پیش فرض ماشین حساب',
        'privacy': 'حریم خصوصی',
        'offlinePrivacyNote':
          'این برنامه کاملا آفلاین کار می کند و هیچ داده ای به سرور ارسال نمی شود.',
    },
  };

  String _get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }

  String get appTitle => _get('appTitle');
  String get home => _get('home');
  String get tools => _get('tools');
  String get education => _get('education');
  String get history => _get('history');
  String get settings => _get('settings');
  String get aboutApp => _get('aboutApp');
  String get aboutSummary => _get('aboutSummary');
  String get developedBy => _get('developedBy');
  String get developerName => _get('developerName');
  String get toolsMainSection => _get('toolsMainSection');
  String get toolsMoreSection => _get('toolsMoreSection');
  String get toolVlsm => _get('toolVlsm');
  String get toolSummarization => _get('toolSummarization');
  String get toolSplitMerge => _get('toolSplitMerge');
  String get toolShareReport => _get('toolShareReport');
  String get toolTemplates => _get('toolTemplates');
  String get toolIpv6PrefixPlanner => _get('toolIpv6PrefixPlanner');
  String get toolReverseDns => _get('toolReverseDns');
  String get toolAddressInspector => _get('toolAddressInspector');
  String get generate => _get('generate');
  String get summarize => _get('summarize');
  String get split => _get('split');
  String get share => _get('share');
  String get remaining => _get('remaining');
  String get summaryRoute => _get('summaryRoute');
  String get inputNetworks => _get('inputNetworks');
  String get range => _get('range');
  String get routePolicyNote => _get('routePolicyNote');
  String get baseNetworkCidr => _get('baseNetworkCidr');
  String get hostNeedsCommaSeparated => _get('hostNeedsCommaSeparated');
  String get subnetListPerLine => _get('subnetListPerLine');
  String get baseCidr => _get('baseCidr');
  String get splitToPrefix => _get('splitToPrefix');
  String get reportText => _get('reportText');
  String get readyTemplates => _get('readyTemplates');
  String get basePrefix48 => _get('basePrefix48');
  String get siteCount => _get('siteCount');
  String get ipAddress => _get('ipAddress');
  String get generatePtr => _get('generatePtr');
  String get address => _get('address');
  String get inspect => _get('inspect');
  String get noResultYet => _get('noResultYet');
  String get noSubnetsAllocated => _get('noSubnetsAllocated');
  String get noSplitResult => _get('noSplitResult');
  String get waste => _get('waste');
  String get site => _get('site');
  String get ptrRecordIpv4 => _get('ptrRecordIpv4');
  String get ptrRecordIpv6 => _get('ptrRecordIpv6');
  String get addressInspectorIpv4Hint => _get('addressInspectorIpv4Hint');
  String get addressInspectorIpv6Hint => _get('addressInspectorIpv6Hint');
  String get shareUnavailableCopied => _get('shareUnavailableCopied');
  String get invalidVlsmInput => _get('invalidVlsmInput');
  String get invalidSummarizationInput => _get('invalidSummarizationInput');
  String get invalidSplitInput => _get('invalidSplitInput');
  String get invalidIpv6PlannerInput => _get('invalidIpv6PlannerInput');
  String get ipv4Private => _get('ipv4Private');
  String get ipv4Public => _get('ipv4Public');
  String get ipv6Loopback => _get('ipv6Loopback');
  String get ipv6LinkLocal => _get('ipv6LinkLocal');
  String get ipv6UniqueLocal => _get('ipv6UniqueLocal');
  String get ipv6Multicast => _get('ipv6Multicast');
  String get ipv6GlobalOther => _get('ipv6GlobalOther');
  String get unknownFormat => _get('unknownFormat');
  String get historyLabelSubnetIpv4 => _get('historyLabelSubnetIpv4');
  String get historyLabelSubnetIpv6 => _get('historyLabelSubnetIpv6');
  String get ipv4Address => _get('ipv4Address');
  String get prefixLength => _get('prefixLength');
  String get ipv4Tab => _get('ipv4Tab');
  String get prefixMaskHint => _get('prefixMaskHint');
  String get calculate => _get('calculate');
  String get ipv6 => _get('ipv6');
  String get comingSoon => _get('comingSoon');
  String get analyzeIpv6 => _get('analyzeIpv6');
  String get ipv6Input => _get('ipv6Input');
  String get ipv6InputHint => _get('ipv6InputHint');
  String get invalidIpv6 => _get('invalidIpv6');
  String get invalidIpv6Prefix => _get('invalidIpv6Prefix');
  String get compressed => _get('compressed');
  String get expanded => _get('expanded');
  String get networkPrefix => _get('networkPrefix');
  String get firstAddress => _get('firstAddress');
  String get lastAddress => _get('lastAddress');
  String get totalAddresses => _get('totalAddresses');
  String get classification => _get('classification');
  String get classificationDescription => _get('classificationDescription');
  String get ipv4Mapped => _get('ipv4Mapped');
  String get yes => _get('yes');
  String get no => _get('no');
  String get ipv6UnderstandTitle => _get('ipv6UnderstandTitle');
  String get ipv6UnderstandBody => _get('ipv6UnderstandBody');
  String get basicMode => _get('basicMode');
  String get advancedMode => _get('advancedMode');
  String get basicModeEnabledHint => _get('basicModeEnabledHint');
  String get advancedModeEnabledHint => _get('advancedModeEnabledHint');
  String get basicModeDetailsHint => _get('basicModeDetailsHint');
  String get advancedModeDetailsHint => _get('advancedModeDetailsHint');
  String get interfaceId => _get('interfaceId');
  String get networkBits => _get('networkBits');
  String get hostBits => _get('hostBits');
  String get ipv4vsIpv6Title => _get('ipv4vsIpv6Title');
  String get ipv4vsIpv6Body => _get('ipv4vsIpv6Body');
  String get compareField => _get('compareField');
  String get compareIpv4 => _get('compareIpv4');
  String get compareIpv6 => _get('compareIpv6');
  String get addressLength => _get('addressLength');
  String get notation => _get('notation');
  String get deliveryModel => _get('deliveryModel');
  String get natUsage => _get('natUsage');
  String get typePracticeTitle => _get('typePracticeTitle');
  String get typePracticeQuestion => _get('typePracticeQuestion');
  String get checkAnswer => _get('checkAnswer');
  String get correctAnswer => _get('correctAnswer');
  String get wrongAnswer => _get('wrongAnswer');
  String get invalidIp => _get('invalidIp');
  String get invalidPrefix => _get('invalidPrefix');
  String get networkAddress => _get('networkAddress');
  String get broadcastAddress => _get('broadcastAddress');
  String get subnetMask => _get('subnetMask');
  String get wildcardMask => _get('wildcardMask');
  String get firstHost => _get('firstHost');
  String get lastHost => _get('lastHost');
  String get usableHosts => _get('usableHosts');
  String get copy => _get('copy');
  String get copied => _get('copied');
  String get language => _get('language');
  String get persian => _get('persian');
  String get english => _get('english');
  String get educationTitle => _get('educationTitle');
  String get historyTitle => _get('historyTitle');
  String get noHistory => _get('noHistory');
  String get clearHistory => _get('clearHistory');
  String get clearHistoryConfirm => _get('clearHistoryConfirm');
  String get cancel => _get('cancel');
  String get clear => _get('clear');
  String get delete => _get('delete');
  String get result => _get('result');
  String get input => _get('input');
  String get calculateSubnet => _get('calculateSubnet');
  String get ipv6Hint => _get('ipv6Hint');
  String get defaultCalculatorTab => _get('defaultCalculatorTab');
  String get privacy => _get('privacy');
  String get offlinePrivacyNote => _get('offlinePrivacyNote');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .map((item) => item.languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

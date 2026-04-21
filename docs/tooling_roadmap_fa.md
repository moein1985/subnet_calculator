# نقشه راه پیاده سازی ابزارهای تکمیلی (بدون گیج کنندگی کاربر)

## هدف
این سند برای پیاده سازی 8 ابزار جدید نوشته شده تا برنامه کاربردی تر شود ولی UX ساده بماند.

اصل کلیدی: هر نسخه فقط 1 یا 2 ابزار جدید اضافه شود و هر ابزار با "حالت ساده" شروع شود.

## اصول UX ضد-گیج کنندگی
- هر ابزار دو سطح داشته باشد:
  - ساده: ورودی حداقلی + خروجی مستقیم
  - پیشرفته: جزئیات بیشتر پشت یک "نمایش جزئیات"
- در صفحه اصلی ابزارها فقط 4 گزینه دیده شوند. بقیه داخل "ابزارهای بیشتر".
- برای هر ابزار یک مثال آماده (Preset) قرار داده شود.
- متن خروجی کوتاه و قابل کپی/اشتراک باشد.
- از اصطلاحات سنگین فقط در Advanced استفاده شود.

## معماری پیشنهادی
- برای هر ابزار یک feature مستقل در lib/features/tool_<name>
- ساختار data/domain/presentation مشابه فیچرهای فعلی
- اشتراکات ریاضی و parsing در lib/core/network_tools
- خروجی همه ابزارها یک مدل Report قابل اشتراک داشته باشند

## اولویت اجرای 8 ابزار

### فاز 1 (بیشترین ارزش با کمترین پیچیدگی)
1) VLSM Planner
- ورودی: شبکه پایه + لیست نیاز میزبان
- خروجی ساده: لیست subnet های تخصیص یافته
- خروجی پیشرفته: CIDR, range, mask, usable hosts

2) CIDR Summarization
- ورودی: چند subnet
- خروجی ساده: summary route
- خروجی پیشرفته: شبکه های merge نشده + علت

### فاز 2 (کاربرد روزمره)
3) Subnet Split/Merge Assistant
- split: مثل /24 به چند /26
- merge: چند subnet مجاور به supernet

4) Export/Share Report
- خروجی تمیز متنی FA/EN
- کپی یکجا + اشتراک مستقیم

### فاز 3 (برای سناریوی عملی تیم ها)
5) Saved Templates
- قالب های آماده: دفتر کوچک، دوربین، شعبه
- اجرای یک کلیکی محاسبات

6) IPv6 Prefix Allocation Planner
- تخصیص سلسله مراتبی /48 -> /56 -> /64
- حالت ساده: تعداد سایت + خروجی prefix های پیشنهادی

### فاز 4 (ابزارهای نیمه تخصصی)
7) Reverse DNS Helper
- تولید PTR برای IPv4 و IPv6
- خروجی قابل کپی برای DNS zone

8) Address Type Inspector (Expanded)
- توضیح عملیاتی برای هر type
- توصیه استفاده/عدم استفاده به زبان ساده

## طراحی ناوبری پیشنهادی (ساده)
- تب Subnet: محاسبات اصلی IPv4/IPv6
- تب Education: آموزش IPv4/IPv6
- تب History: تاریخچه
- تب Settings: تنظیمات
- صفحه جدید Tools:
  - کارت های اصلی: VLSM, Summarization, Split/Merge, Reports
  - بخش "ابزارهای بیشتر": Prefix Planner, Reverse DNS, Templates, Inspector

## برنامه انتشار تدریجی
- نسخه 1.1: VLSM + CIDR Summarization
- نسخه 1.2: Split/Merge + Share Report
- نسخه 1.3: Templates + IPv6 Prefix Planner
- نسخه 1.4: Reverse DNS + Inspector

## معیار پذیرش برای هر ابزار
- ورودی نامعتبر پیام خطای انسانی داشته باشد.
- حالت ساده در کمتر از 3 ورودی نتیجه بدهد.
- حالت پیشرفته قابل پنهان/نمایش باشد.
- خروجی کپی/اشتراک پذیری داشته باشد.
- حداقل 5 تست واحد و 1 تست ویجت برای هر ابزار.

## نقطه شروع پیشنهادی (Sprint بعدی)
1) پیاده سازی VLSM Planner (Simple + Advanced)
2) پیاده سازی CIDR Summarization (Simple + Advanced)
3) یک مدل خروجی مشترک برای Share Report

اگر این سند تایید شود، قدم بعدی ایجاد اسکلت feature های فاز 1 و تعریف task های فنی خردشده خواهد بود.

## شماتیک کلی محصول بعد از پیاده سازی 8 ابزار

### 1) نقشه کلی ناوبری برنامه

```text
Bottom Navigation
├─ Subnet
│  ├─ IPv4 (Simple/Advanced)
│  └─ IPv6 (Simple/Advanced)
├─ Tools
│  ├─ ابزارهای اصلی (4 کارت)
│  │  ├─ VLSM Planner
│  │  ├─ CIDR Summarization
│  │  ├─ Split/Merge Assistant
│  │  └─ Share Report
│  └─ ابزارهای بیشتر
│     ├─ Saved Templates
│     ├─ IPv6 Prefix Planner
│     ├─ Reverse DNS Helper
│     └─ Address Type Inspector
├─ Education
│  ├─ IPv4
│  └─ IPv6
├─ History
└─ Settings
```

### 2) ظاهر صفحه Tools (پس از تکمیل)

```text
+--------------------------------------------------+
| AppBar: Tools                                   |
| Search (اختیاری در نسخه بعد)                    |
+--------------------------------------------------+
| ابزارهای اصلی                                    |
| [VLSM] [Summarization]                          |
| [Split/Merge] [Share Report]                    |
+--------------------------------------------------+
| ابزارهای بیشتر                                   |
| - Templates                                     |
| - IPv6 Prefix Planner                           |
| - Reverse DNS                                   |
| - Address Type Inspector                        |
+--------------------------------------------------+
| نکته UX: هر کارت یک توضیح یک خطی ساده دارد       |
+--------------------------------------------------+
```

### 3) شماتیک داخلی هر ابزار (الگوی یکسان)

```text
Tool Screen
├─ Header: نام ابزار + توضیح کوتاه
├─ Mode Switch: Simple | Advanced
├─ Input Section
│  ├─ ورودی های اصلی
│  └─ Preset / Example
├─ Action: Calculate / Generate
├─ Result Section
│  ├─ خلاصه (همیشه قابل مشاهده)
│  └─ جزئیات (فقط در Advanced یا Expand)
└─ Bottom Actions
  ├─ Copy
  ├─ Share
  └─ Save to History
```

### 4) تجربه کاربر در 3 سناریوی اصلی

#### سناریوی A: کاربر مبتدی
```text
Home -> Tools -> VLSM (Simple)
-> وارد کردن 2 یا 3 مقدار
-> دریافت خروجی خلاصه
-> Copy/Share
```

#### سناریوی B: کاربر نیمه حرفه ای
```text
Home -> Tools -> Summarization
-> وارد کردن چند subnet
-> دیدن summary route
-> باز کردن جزئیات merge نشده
-> ذخیره در History
```

#### سناریوی C: کاربر حرفه ای شبکه
```text
Home -> Tools -> IPv6 Prefix Planner (Advanced)
-> تعریف /48 مبنا + تعداد سایت
-> دریافت /56 و /64 های پیشنهادی
-> Export report
```

### 5) شکل خروجی تاریخچه پس از افزودن ابزارها

```text
History Item (Unified)
├─ Tool: VLSM | Summarization | Subnet | IPv6 | ...
├─ Input Summary: ورودی کوتاه
├─ Output Summary: نتیجه اصلی
├─ Timestamp
└─ Actions: Reuse | Share | Delete
```

### 6) قانون ساده سازی برای جلوگیری از شلوغی

```text
اگر ابزار جدید اضافه شد:
1) ابتدا فقط در بخش "ابزارهای بیشتر" قرار بگیرد
2) اگر استفاده بالا داشت به "ابزارهای اصلی" منتقل شود
3) در هر نسخه حداکثر 2 تغییر UI بزرگ انجام شود
```

### 7) تصویر نهایی محصول (خلاصه یک خطی)

```text
Subnet Calculator => یک هاب سبک و سریع برای Subnetting + Tooling + Education
با دو لایه استفاده:
- سریع و ساده برای کاربر عمومی
- عمیق و دقیق برای کاربر فنی
```

## پیاده سازی عملی فاز 1 (شروع اجرا)

### 1) User Flow دقیق برای VLSM Planner

```text
Tools -> VLSM Planner
-> پیش فرض: Simple
-> ورودی ها:
  - Base Network (مثل 192.168.10.0/24)
  - Host Needs (مثل 60,30,12)
-> دکمه Generate
-> خروجی Simple:
  - لیست subnet های تخصیص یافته به ترتیب
  - Remaining Capacity
-> اکشن ها: Copy | Share | Save
-> (اختیاری) سوییچ به Advanced
-> خروجی Advanced:
  - CIDR + Mask + First/Last + Usable + Waste
```

### 2) User Flow دقیق برای CIDR Summarization

```text
Tools -> CIDR Summarization
-> پیش فرض: Simple
-> ورودی ها:
  - Subnet List (چند خطی)
-> دکمه Summarize
-> خروجی Simple:
  - Best Summary Route
  - Total Input Networks
-> اکشن ها: Copy | Share | Save
-> سوییچ به Advanced
-> خروجی Advanced:
  - Fully merged routes
  - Non-mergeable routes + دلیل
```

### 3) شماتیک صفحه های فاز 1

#### صفحه Tools (نسخه فاز 1)
```text
+---------------------------------------------+
| Tools                                       |
+---------------------------------------------+
| [VLSM Planner]   [CIDR Summarization]      |
| [Split/Merge]    [Share Report] (disabled) |
+---------------------------------------------+
| ابزارهای بیشتر (غیرفعال تا فازهای بعد)       |
+---------------------------------------------+
```

#### صفحه VLSM Planner
```text
+---------------------------------------------+
| VLSM Planner                               |
| [Simple | Advanced]                        |
+---------------------------------------------+
| Base Network: [________________________]   |
| Host Needs:   [________________________]   |
| Preset: Office 50/20/10                    |
| [Generate]                                  |
+---------------------------------------------+
| Result Summary                              |
| - Subnet 1                                  |
| - Subnet 2                                  |
| - Remaining                                 |
| [Copy] [Share] [Save]                       |
+---------------------------------------------+
```

#### صفحه CIDR Summarization
```text
+---------------------------------------------+
| CIDR Summarization                         |
| [Simple | Advanced]                        |
+---------------------------------------------+
| Subnet List (one per line):                |
| [_______________________________]          |
| [Summarize]                                 |
+---------------------------------------------+
| Summary Result                              |
| - 10.0.0.0/22                               |
| [Copy] [Share] [Save]                       |
+---------------------------------------------+
```

### 4) رفتار UX برای جلوگیری از گیج شدن در فاز 1

- Simple همیشه پیش فرض باشد.
- در Simple حداکثر 3 خروجی کلیدی نمایش داده شود.
- بخش Advanced با "نمایش جزئیات" باز شود، نه به صورت پیش فرض.
- پیام خطا با مثال اصلاحی نمایش داده شود.
  - مثال: "فرمت نامعتبر است. نمونه صحیح: 192.168.1.0/24"
- پس از هر محاسبه موفق، یک SnackBar کوتاه نشان داده شود:
  - "نتیجه آماده است. می توانید کپی یا ذخیره کنید."

### 5) تسک های فنی خردشده (Sprint 1)

1) ایجاد feature جدید VLSM
- `lib/features/tool_vlsm/data`
- `lib/features/tool_vlsm/domain`
- `lib/features/tool_vlsm/presentation`

2) ایجاد feature جدید Summarization
- `lib/features/tool_summarization/data`
- `lib/features/tool_summarization/domain`
- `lib/features/tool_summarization/presentation`

3) ایجاد مدل مشترک گزارش
- `lib/core/network_tools/report_model.dart`
- خروجی یکپارچه برای Copy/Share/Save
4) افزودن مسیرها در Router
- `/tools`
- `/tools/vlsm`
- `/tools/summarization`

5) اتصال History
- ذخیره نتیجه هر ابزار با `toolType`
- قابلیت Reuse برای هر ابزار

6) تست های حداقلی Sprint 1
- VLSM: حداقل 5 unit test
- Summarization: حداقل 5 unit test
- Tools navigation: حداقل 2 widget test

### 6) Definition of Done برای فاز 1

- کاربر از صفحه Tools بتواند هر دو ابزار را اجرا کند.
- هر دو ابزار در حالت Simple خروجی قابل فهم تولید کنند.
- Advanced فقط جزئیات اضافه کند و رفتار را پیچیده نکند.
- خروجی قابل Copy و Save در History باشد.
- `flutter analyze` و `flutter test` سبز باشند.

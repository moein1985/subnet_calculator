import '../../domain/entities/education_article.dart';
import '../../domain/repositories/education_repository.dart';

class EducationRepositoryImpl implements EducationRepository {
  const EducationRepositoryImpl();

  @override
  Future<List<EducationArticle>> getArticles() async {
    return const [
      EducationArticle(
        track: EducationTrack.ipv4,
        titleEn: 'Lesson 1: What is an IP address?',
        titleFa: 'درس 1: آدرس IP چیست؟',
        contentEn:
            'Every device in a network needs an address to send and receive data.\n\nIPv4 uses 32 bits and is usually shown as four numbers (for example 192.168.1.10).\nIPv6 uses 128 bits and provides a much larger address space.',
        contentFa:
            'هر دستگاه در شبکه برای ارسال و دریافت داده به یک آدرس نیاز دارد.\n\nIPv4 از 32 بیت استفاده می کند و معمولا به صورت چهار عدد نمایش داده می شود (مثلا 192.168.1.10).\nIPv6 از 128 بیت استفاده می کند و فضای آدرسی بسیار بزرگ تری دارد.',
      ),
      EducationArticle(
        track: EducationTrack.ipv4,
        titleEn: 'Lesson 2: Prefix and Subnet Mask',
        titleFa: 'درس 2: Prefix و Subnet Mask',
        contentEn:
            'Prefix length like /24 means 24 bits are for the network part and remaining bits are for hosts.\n\nSubnet mask is another way to write the same concept (for /24, mask is 255.255.255.0).',
        contentFa:
            'طول پیشوند مانند /24 یعنی 24 بیت مربوط به بخش شبکه است و بیت های باقی مانده برای میزبان ها استفاده می شود.\n\nSubnet Mask روش دیگری برای بیان همین مفهوم است (برای /24 مقدار ماسک برابر 255.255.255.0 است).',
      ),
      EducationArticle(
        track: EducationTrack.ipv4,
        titleEn: 'Lesson 3: Network and Broadcast',
        titleFa: 'درس 3: Network و Broadcast',
        contentEn:
            'Network address is the first address of the subnet.\nBroadcast is the last address in IPv4 and is used to send data to all hosts in that subnet.',
        contentFa:
            'آدرس Network اولین آدرس سابنت است.\nآدرس Broadcast آخرین آدرس در IPv4 است و برای ارسال داده به همه میزبان های همان سابنت استفاده می شود.',
      ),
      EducationArticle(
        track: EducationTrack.ipv4,
        titleEn: 'Lesson 4: Host range and usable hosts',
        titleFa: 'درس 4: بازه میزبان ها و تعداد قابل استفاده',
        contentEn:
            'Host range is between first host and last host.\n\nFor most subnets:\nUsable Hosts = 2^(32-prefix) - 2\n\nSpecial cases:\n/31 has 2 usable addresses\n/32 has 1 usable address.',
        contentFa:
            'بازه میزبان ها بین اولین میزبان تا آخرین میزبان است.\n\nدر اکثر سابنت ها:\nتعداد میزبان قابل استفاده = 2^(32-prefix) - 2\n\nحالت های ویژه:\n/31 دارای 2 آدرس قابل استفاده\n/32 دارای 1 آدرس قابل استفاده.',
      ),
      EducationArticle(
        track: EducationTrack.ipv4,
        titleEn: 'Lesson 5: IPv4 vs IPv6',
        titleFa: 'درس 5: تفاوت IPv4 و IPv6',
        contentEn:
            'IPv6 offers a huge address space, better hierarchical routing, and easier auto-configuration.\n\nIPv4 is still common, but IPv6 adoption is growing quickly.',
        contentFa:
            'IPv6 فضای آدرسی بسیار بزرگ، مسیریابی سلسله مراتبی بهتر و پیکربندی خودکار ساده تری ارائه می دهد.\n\nIPv4 هنوز رایج است، اما مهاجرت به IPv6 به سرعت در حال افزایش است.',
      ),
      EducationArticle(
        track: EducationTrack.ipv4,
        titleEn: 'Lesson 6: Common mistakes',
        titleFa: 'درس 6: خطاهای رایج',
        contentEn:
            '1) Mixing prefix and mask incorrectly\n2) Using invalid masks like 255.0.255.0\n3) Confusing network address with host address\n4) Ignoring broadcast in IPv4 designs',
        contentFa:
            '1) ترکیب نادرست prefix و mask\n2) استفاده از ماسک نامعتبر مانند 255.0.255.0\n3) اشتباه گرفتن آدرس شبکه با آدرس میزبان\n4) نادیده گرفتن آدرس Broadcast در طراحی IPv4',
      ),
      EducationArticle(
        track: EducationTrack.ipv4,
        titleEn: 'Lesson 7: Real-world office example',
        titleFa: 'درس 7: مثال واقعی دفتر کوچک',
        contentEn:
            'Suppose you have 50 devices. A /26 subnet gives 62 usable hosts and is usually enough.\n\nIf growth is expected, /25 may be a safer choice.',
        contentFa:
            'فرض کنید 50 دستگاه دارید. یک سابنت /26 تعداد 62 میزبان قابل استفاده می دهد و معمولا کافی است.\n\nاگر رشد شبکه محتمل است، /25 انتخاب مطمئن تری است.',
      ),
      EducationArticle(
        track: EducationTrack.ipv4,
        titleEn: 'Lesson 8: Step-by-step subnet workflow',
        titleFa: 'درس 8: روند مرحله ای محاسبه سابنت',
        contentEn:
            'Step 1: Read IP\nStep 2: Convert prefix/mask\nStep 3: Compute network\nStep 4: Compute broadcast\nStep 5: Determine host range\nStep 6: Verify usable hosts',
        contentFa:
            'مرحله 1: خواندن IP\nمرحله 2: تبدیل prefix/mask\nمرحله 3: محاسبه network\nمرحله 4: محاسبه broadcast\nمرحله 5: تعیین بازه میزبان\nمرحله 6: بررسی تعداد قابل استفاده',
      ),
      EducationArticle(
        track: EducationTrack.ipv4,
        titleEn: 'Lesson 9: IPv4 common mistakes checklist',
        titleFa: 'درس 9: چک لیست خطاهای رایج IPv4',
        contentEn:
            'Checklist before finalizing subnet design:\n1) Prefix/mask are equivalent\n2) Network and host addresses are not mixed\n3) Broadcast is considered\n4) Host capacity matches real device count\n5) Growth margin is included',
        contentFa:
            'چک لیست قبل از نهایی کردن طراحی سابنت:\n1) prefix و mask معادل هستند\n2) آدرس شبکه با آدرس میزبان اشتباه نشده\n3) broadcast در نظر گرفته شده\n4) ظرفیت میزبان با تعداد واقعی دستگاه ها سازگار است\n5) حاشیه رشد شبکه دیده شده است',
      ),
      EducationArticle(
        track: EducationTrack.ipv6,
        titleEn: 'Lesson 10: Reading IPv6 addresses',
        titleFa: 'درس 10: خواندن آدرس های IPv6',
        contentEn:
            'IPv6 uses 8 hex groups separated by colons. Leading zeros in each group can be omitted, and one longest all-zero run can be compressed with ::.\n\nExample:\n2001:0db8:0000:0000:0000:0000:0000:0001\nbecomes\n2001:db8::1',
        contentFa:
            'IPv6 از 8 گروه هگز جدا شده با : تشکیل می شود. صفرهای ابتدایی هر گروه قابل حذف هستند و یک دنباله طولانی صفر می تواند با :: فشرده شود.\n\nمثال:\n2001:0db8:0000:0000:0000:0000:0000:0001\nبه\n2001:db8::1\nتبدیل می شود.',
      ),
      EducationArticle(
        track: EducationTrack.ipv6,
        titleEn: 'Lesson 11: IPv6 address types',
        titleFa: 'درس 11: انواع آدرس در IPv6',
        contentEn:
            'Important types:\n- Global Unicast (2000::/3): public routing\n- Link-local (fe80::/10): local link only\n- Unique Local (fc00::/7): private routing\n- Multicast (ff00::/8): one-to-many delivery\n- Loopback (::1): local host',
        contentFa:
            'انواع مهم:\n- Global Unicast (2000::/3): مسیریابی عمومی\n- Link-local (fe80::/10): فقط لینک محلی\n- Unique Local (fc00::/7): مسیریابی خصوصی\n- Multicast (ff00::/8): ارسال یک به چند\n- Loopback (::1): میزبان محلی',
      ),
      EducationArticle(
        track: EducationTrack.ipv6,
        titleEn: 'Lesson 12: IPv6 subnetting in practice',
        titleFa: 'درس 12: سابنتینگ IPv6 در عمل',
        contentEn:
            'In enterprise LANs, /64 is the common subnet size.\n\nFor IPv6 planning, focus on:\n1) clean prefix hierarchy\n2) consistent per-site allocation\n3) tracking first/last address and total capacity',
        contentFa:
            'در شبکه های سازمانی، /64 اندازه رایج سابنت است.\n\nبرای طراحی IPv6 روی این موارد تمرکز کنید:\n1) سلسله مراتب تمیز پیشوندها\n2) تخصیص یکنواخت برای هر سایت\n3) بررسی اولین/آخرین آدرس و ظرفیت کل',
      ),
    ];
  }
}

import '../entities/education_article.dart';

abstract class EducationRepository {
  Future<List<EducationArticle>> getArticles();
}

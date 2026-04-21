import '../entities/education_article.dart';
import '../repositories/education_repository.dart';

class GetEducationArticlesUseCase {
  GetEducationArticlesUseCase(this._repository);

  final EducationRepository _repository;

  Future<List<EducationArticle>> call() {
    return _repository.getArticles();
  }
}

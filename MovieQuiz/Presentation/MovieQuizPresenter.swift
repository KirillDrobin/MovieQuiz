import UIKit

final class MovieQuizPresenter {
    //номер текущего вопроса
    private var currentQuestionIndex = 0
    
    //количества вопросов в сесии
    let questionsAmount: Int = 10
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    //метод создания вью модели вопроса из структуры QuizQuestion
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let image = UIImage(data: model.image) ?? UIImage()
        
        let currentQuestion = QuizStepViewModel(image: image,
                                                question: model.text,
                                                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return currentQuestion
    }
}

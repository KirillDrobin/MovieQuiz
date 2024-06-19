import UIKit

final class MovieQuizPresenter {
    //номер текущего вопроса
    private var currentQuestionIndex = 0
    
    //количества вопросов в сесcии
    let questionsAmount: Int = 10
    
    var currentQuestion: QuizQuestion?
    
    weak var viewController: MovieQuizViewController?
    
    
    //метод создания вью модели вопроса из структуры QuizQuestion
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let image = UIImage(data: model.image) ?? UIImage()
        
        let currentQuestion = QuizStepViewModel(image: image,
                                                question: model.text,
                                                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return currentQuestion
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
}

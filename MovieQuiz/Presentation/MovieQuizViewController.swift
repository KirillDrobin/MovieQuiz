import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterProtocol {
    
    // MARK: - Lifecycle
    
    //номер текущего вопроса
    private var currentQuestionIndex = 0
    
    //количество правильных ответов
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenterDelegate: AlertPresenterDelegate?
    
    private var alertPresenter: AlertPresenterProtocol?
    
    private var statisticService: StatisticService?
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var yesButton: UIButton!
    
    @IBOutlet private var noButton: UIButton!
    
    @IBOutlet weak var questionField: UILabel!
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        clearBorder()
        textLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionField.font = UIFont(name: "YSDisplay-Bold", size: 23)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
        
        let alertPresenterDelegate = AlertPresenter()
        alertPresenterDelegate.alertView = self
        self.alertPresenterDelegate = alertPresenterDelegate
        
        statisticService = StatisticService()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        show(quiz: viewModel)
        
        DispatchQueue.main.async {
            self.show(quiz: viewModel)
        }
    }
    
    //функция создания вью модели вопроса из структуры QuizQuestion
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let currentQuestion = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return currentQuestion
    }
    
    //функция вывода вопроса
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionField.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // MARK: - AlertPresenterProtocol
    func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            
            let messageText = "Ваш результат: \(correctAnswers)/\(questionsAmount) \n" + "Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0) \n" + "Рекорд: \(statisticService?.bestGame.correct ?? 0)/\(questionsAmount) (\(statisticService?.bestGame.date.dateTimeString ?? " ")) \n" + "Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0))%"
            
            let alertModel = AlertModel(title: "Этот раунд окончен!",
                                        message: messageText,
                                        buttonText:"Сыграть еще раз",
                                        completion: {[weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory.requestNextQuestion()
            })
            alertPresenterDelegate?.alertShow(alertModel: alertModel)
        } else {
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
    }
    
    //функция вывода результата ответа на вопрос
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
            yesButton.isEnabled = true
            noButton.isEnabled = true
            clearBorder()
        }
        
    }
    
    //функция отображения скругления постера
    private func clearBorder() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}

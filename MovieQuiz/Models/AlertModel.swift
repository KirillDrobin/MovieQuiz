//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Кирилл Дробин on 23.05.2024.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: () -> Void
}

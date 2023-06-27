//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Ann Goncharova on 25.06.2023.
//



import XCTest
@testable import ImageFeed

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        app.launch() // запуск приложения перед каждым тестом
    }
    
    func testAuth() throws { // тест сценария авторизации
        /*
         У приложения мы получаем список кнопок на экране и получаем нужную кнопку по тексту на ней
         Далее вызываем функцию tap() для нажатия на этот элемент
         */
        app.buttons["Authenticate"].tap() // нажатие кнопки авторизации
        //sleep(5)
        // ждем, пока экран авторизации открывается и загружается
        let webView = app.webViews["UnsplashWebView"]
        sleep(5)
        print(webView.buttons)
        let loginTextField = webView.descendants(matching: .textField).element // ввод данных в форму
        sleep(5)
        
        loginTextField.tap()
        loginTextField.typeText("") // здесь вводим логин приложения
        loginTextField.swipeUp() // скрываем клавиатуру после ввода текста
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        sleep(5)
        
        passwordTextField.tap()
        passwordTextField.typeText("") // здесь вводим пароль приложения
        webView.swipeUp()
        
        // тап по кнопке логина
        let webViewsQuery = app.webViews
        webViewsQuery.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        sleep(5)
        //XCTAssertTrue(cell.waitForExistence(timeout: 5)) // ждем пока открывается экран ленты
        print(app.debugDescription)
    }
    
    func testFeed() throws { // тест ленты
        
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["likeButton"].tap()
        sleep(5)
        
        cellToLike.buttons["likeButton"].tap()
        sleep(5)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav_back_button"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts[""].exists)
        XCTAssertTrue(app.staticTexts[""].exists)
        
        app.buttons["logout button"].tap()
        app.alerts["Пока, пока"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(2)
        
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 5))
    }
}

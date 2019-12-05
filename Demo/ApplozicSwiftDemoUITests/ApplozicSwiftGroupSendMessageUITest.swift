//
//  ApplozicSwiftGroupUITest.swift
//  ApplozicSwiftDemoUITests
//
//  Created by Kommunicate on 26/11/19.
//  Copyright © 2019 Applozic. All rights reserved.
//

import XCTest

class ApplozicSwiftGroupSendMessageUITest: XCTestCase {
    
    enum GroupData {
        static let groupMember1 = "GroupMember1"
        static let groupMember2 = "GroupMember2"
        static let typeText = "Hello Applozic"
        static let fillUserId = "LoginUserId"
        static let fillPassword = "LoginUserPassword"
    }
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        //This is important to ensure that the notification permission popup is handled when the app launches for the first time.
        addUIInterruptionMonitor(withDescription: AppPermission.AlertMessage.accessNotificationInApplication ) { (alerts) -> Bool in
            if(alerts.buttons[AppPermission.AlertButton.allow].exists){
                alerts.buttons[AppPermission.AlertButton.allow].tap();
            }
            return true;
        }
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        sleep(5)
        
        //First Login.
        guard !XCUIApplication().scrollViews.otherElements.buttons[InAppButton.LaunchScreen.getStarted].exists else{
            login()
            return
        }
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSendTextMessageInGroup() {
        let groupName = "DemogroupForText"
        let app = beforeStartTest_CreateAGroup_And_EnterInConversation(groupName: groupName) // Click on launch conversation and then create a group
        sleep(3)
        let inputView = app.otherElements[AppScreen.chatBar ].children(matching: .textView).matching(identifier: AppTextFeild.chatTextView).firstMatch
        
        inputView.tap()
        sleep(2)
        inputView.typeText(GroupData.typeText) // typeing message
        
        app.buttons[InAppButton.ConversationScreen.send].tap() // sending message in group
        sleep(3)
        deleteAGroup_FromConversationList_After_SendMessageInGroup(app : app) //leave the group and delete group
    }
    
    func testSendImageInGroup(){
        let groupName = "DemoGroupForImage"
        let app = beforeStartTest_CreateAGroup_And_EnterInConversation(groupName: groupName) // Click on launch conversation and then create a group
        sleep(3)
        app.buttons[InAppButton.ConversationScreen.openPhotos].tap() // Click on photo button
        addUIInterruptionMonitor(withDescription: AppPermission.AlertMessage.accessPhoto ) { (alerts) -> Bool in
            if(alerts.buttons[AppPermission.AlertButton.ok].exists){
                alerts.buttons[AppPermission.AlertButton.ok].tap();
            }
            return true;
        }
        app.tap()
        sleep(1)
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.tap()
        app.navigationBars[InAppButton.ConversationScreen.selectPhoto].buttons[InAppButton.ConversationScreen.done].tap() // selecting photo and then sending
        sleep(3)
        deleteAGroup_FromConversationList_After_SendMessageInGroup(app : app) //leave the group and delete group
    }
    
    func testSendContactInGroup(){
        let groupName = "DemoGroupForContact"
        let app = beforeStartTest_CreateAGroup_And_EnterInConversation(groupName: groupName) // Click on launch conversation and then create a group
        sleep(3)
        app.buttons[InAppButton.ConversationScreen.openContact].tap() // Click on Contact button
        addUIInterruptionMonitor(withDescription: AppPermission.AlertMessage.accessContact) { (alerts) -> Bool in
            if(alerts.buttons[AppPermission.AlertButton.ok].exists){
                alerts.buttons[AppPermission.AlertButton.ok].tap();
            }
            return true;
        }
        app.tap()
        sleep(2)
        app.tables[InAppButton.ConversationScreen.selectcontact].tap() // selection any conatct and than sending
        sleep(3)
        deleteAGroup_FromConversationList_After_SendMessageInGroup(app : app) //leave the group and delete group
    }
    
    func testSendLocationInGroup(){
     let groupName = "DemoGroupForLocation"
        let app = beforeStartTest_CreateAGroup_And_EnterInConversation(groupName: groupName) // Click on launch conversation and then create a group
        sleep(3)
        app.buttons[InAppButton.ConversationScreen.openLocation ].tap() // click on location button
        addUIInterruptionMonitor(withDescription: AppPermission.AlertMessage.accessLocation) { (alerts) -> Bool in
            if(alerts.buttons[AppPermission.AlertButton.allowLoation].exists){
                alerts.buttons[AppPermission.AlertButton.allowLoation].tap();
            }
            return true;
        }
        app.tap()
        sleep(2)
        app.buttons[InAppButton.ConversationScreen.sendLocation].tap() // sending current location
        sleep(3)
        deleteAGroup_FromConversationList_After_SendMessageInGroup(app : app) //leave the group and delete group
    }
    
    private func login() {
        let path = Bundle(for: ApplozicSwiftGroupSendMessageUITest.self).url(forResource: "Info", withExtension: "plist")
        let dict = NSDictionary(contentsOf: path!) as? [String: Any]
        let userId = dict![GroupData.fillUserId]
        let password = dict![GroupData.fillPassword]
        XCUIApplication().tap()
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        let userIdTextField = elementsQuery.textFields[AppTextFeild.userId]
        userIdTextField.tap()
        userIdTextField.typeText(userId as! String)
        let passwordSecureTextField = elementsQuery.secureTextFields[AppTextFeild.password]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password as! String)
        elementsQuery.buttons[InAppButton.LaunchScreen.getStarted].tap()
    }
    
    private func beforeStartTest_CreateAGroup_And_EnterInConversation(groupName: String) -> (XCUIApplication){
        let app = XCUIApplication()
        let path = Bundle(for: ApplozicSwiftGroupSendMessageUITest.self).url(forResource: "Info", withExtension: "plist")
        let dict = NSDictionary(contentsOf: path!) as? [String: Any]
        sleep(2)
        app.buttons[InAppButton.LaunchScreen.launchChat].tap()
        sleep(2)
        app.navigationBars[AppScreen.myChatScreen].buttons[InAppButton.CreatingGroup.newChat].tap()
        sleep(1)
        app.tables.staticTexts[InAppButton.CreatingGroup.createGroup].tap()
        
        let typeGroupNameTextField = app.textFields[AppTextFeild.typeGroupName]
        typeGroupNameTextField.tap()
        sleep(1)
        typeGroupNameTextField.typeText(groupName)
        app.collectionViews.staticTexts[InAppButton.CreatingGroup.addParticipant].tap()
        sleep(2)
        let selectparticipanttableviewTable = app.tables[AppScreen.selectParticipantView]
        selectparticipanttableviewTable.staticTexts[dict![GroupData.groupMember1] as! String].tap()
        selectparticipanttableviewTable.staticTexts[dict![GroupData.groupMember2] as! String].tap()
        app.buttons[InAppButton.CreatingGroup.invite].tap()
        return app
    }
    
    func deleteAGroup_FromConversationList_After_SendMessageInGroup(app: XCUIApplication){
     app.navigationBars[AppScreen.myChatScreen].buttons[InAppButton.ConversationScreen.back].tap()
        let outerchatscreentableviewTable = app.tables[AppScreen.conversationList]
         if outerchatscreentableviewTable.cells.count == 0 {
            return
        }
        outerchatscreentableviewTable.cells.allElementsBoundByIndex.first?.swipeRight()
        sleep(1)
        outerchatscreentableviewTable.buttons[InAppButton.ConversationScreen.swippableDelete].tap()
        app.alerts.scrollViews.otherElements.buttons[InAppButton.CreatingGroup.leave].tap()
        sleep(8)
        if outerchatscreentableviewTable.cells.count == 0 {
            return
        }
        outerchatscreentableviewTable.cells.allElementsBoundByIndex.first?.swipeRight()
           sleep(1)
        outerchatscreentableviewTable.buttons[InAppButton.ConversationScreen.swippableDelete].tap()
        app.alerts.scrollViews.otherElements.buttons[InAppButton.CreatingGroup.remove].tap()
    }
}

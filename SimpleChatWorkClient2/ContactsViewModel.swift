//
//  ContactsViewModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/19.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class ContactsViewModel: NSObject {
    
    // MARK: - Properties
    
    var model: ContactListModel = ContactListModel.sharedInstance
    
    var contacts: Array<ContactModel> = []
    
    // MARK: - Singleton
    
    class var sharedInstance: ContactsViewModel {
        struct Static {
            static let instance: ContactsViewModel = ContactsViewModel()
        }
        return Static.instance
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Method
    
    // コンタクトリストを取得する
    func getContacts(callback:() -> Void) {
        model.getContacts({contacts in
            self.contacts = contacts as Array
            
            callback()
        })
    }
}

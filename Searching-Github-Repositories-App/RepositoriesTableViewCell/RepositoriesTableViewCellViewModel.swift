//
//  RepositoriesTableViewCellViewModel.swift
//  Searching-Github-Repositories-App
//
//  Created by Apple on 2022/11/21.
//

import Foundation

class RepositoriesTableViewCellViewModel {
    //MARK: - Properties
    private var name: String = ""
    private var owner: String = ""
}

//MARK: - Functions
extension RepositoriesTableViewCellViewModel {
    //MARK: - Update
    func updateProperties(name: String, owner: String) {
        self.name = name
        self.owner = owner
    }
    
    //MARK: - Get
    func getName() -> String {
        return self.name
    }
    
    func getOwner() -> String {
        return self.owner
    }
}

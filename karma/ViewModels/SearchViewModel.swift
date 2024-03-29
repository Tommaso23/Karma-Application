//
//  SearchViewModel.swift
//  karma
//
//  Created by Tommaso Bucaioni on 05/01/23.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var searchText = ""
    @Published var collections = [Collection]()
    let userService = UserService()
    let collectionService = CollectionService()
    
    var searchableCollections: [Collection] {
        if searchText.isEmpty {
            return collections
        } else {
            
            let lowercasedQuery = searchText.lowercased()
            return collections.filter({
                
                $0.title.lowercased().contains(lowercasedQuery) ||
                $0.caption.lowercased().contains(lowercasedQuery)
            })
        }
        
    }
    
    var searchableUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            let lowercasedQUery = searchText.lowercased()
            
            return users.filter({
                $0.username.contains(lowercasedQUery) ||
                $0.fullname.lowercased().contains(lowercasedQUery)
            })
        }
    }
        
    
    
    init() {
        fetchUsers()
        fetchCollections()
    }
    
    func fetchUsers() {
        userService.fetchUsers { users in
            self.users = users
        }
    }
    
    func fetchCollections() {
        collectionService.fetchCollections { collections in
            self.collections = collections
            for i in 0 ..< collections.count {
                let uid = collections[i].uid
                self.userService.fetchUser(withUid: uid) { user in
                    self.collections[i].user = user
                }
            }
        }
    }
        
}

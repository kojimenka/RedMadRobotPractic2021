//
//  ProfileInfoRequestViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 08.05.2021.
//

import Foundation

protocol ProfileInfoRequestViewModelProtocol {
    init(userInfoService: UserInfoServiceProtocol)
    func getUserInfo()
}

final class ProfileInfoRequestViewModel: ProfileInfoRequestViewModelProtocol {
    
    // MARK: - Private properties
    
    private var userInfoService: UserInfoServiceProtocol
    
    // MARK: - Init
    
    init(userInfoService: UserInfoServiceProtocol = ServiceLayer.shared.userInfoService) {
        self.userInfoService = userInfoService
    }
    
    // MARK: - Public Methods
    
    public func getUserInfo() {
        
    }
    
}

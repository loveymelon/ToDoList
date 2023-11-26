//
//  KakaoUserInfo.swift
//  ToDoList
//
//  Created by 김진수 on 2023/11/14.
//

import Foundation
//Ats 보안 설정을 하지않아 통신하기전 보안에 막힘
//Ats 관련된 설정을 info로 바꿈
//반드시 codable로 수정할 것
class KakaoUserInfo: Codable {
    var registrationId: String?
    var id: String?
    var pw: String?
    var name: String?
    var imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case registrationId = "registration_id"
        case imageUrl = "image_url"
        case id, pw, name
    }
}

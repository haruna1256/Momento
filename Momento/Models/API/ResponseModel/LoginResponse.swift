//
//  LoginResponse.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/06.
//

// ログイン後に取得する要素の定義
struct LoginResponse: Decodable {
    let user: User
    let token: String
}

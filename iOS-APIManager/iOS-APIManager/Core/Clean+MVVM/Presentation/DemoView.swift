//
//  LoginView.swift
//  fengshui-ios
//
//  Created by Sophearath.chhan  on 22/5/26.
//

import SwiftUI

struct DemoView: View {
    
  
    
    var body: some View {
        VStack(spacing: 16) {

        }
        .padding()
    }
}

//This is a clean real-project style: View only shows UI, ViewModel handles logic, UseCase handles business rule, Repository hides data source, and Service calls API.
//View → ViewModel → UseCase → Repository Protocol → Repository Impl → Service/API

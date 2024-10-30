//
//  Actions.swift
//  PackageReference
//
//  Created by Mark Dubouzet on 10/30/24.
//

import Foundation
import SwiftUI

//MARK: - Actions

struct ActionsView: View {
    @State private var message = "Waiting for action..."
    var simpleAction: () -> Void {
        return {
            print("Simple Action")
        }
    }
    
    var complexAction: () -> Void {
        return {
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            
            let formattedDate = formatter.string(from: currentDate)
            
            if self.message == "Waiting for action..." {
                self.message = "Action performed at \(formattedDate)"
            } else {
                self.message = "Action performed again at \(formattedDate)"
            }
        }
    }
    
    
    var body: some View {
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(message)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding()
            
            HStack {
                Button(action: simpleAction, label: {
                    Text("Simple")
                        .font(.system(size: 20))
                }).padding()
                Button(action: complexAction, label: {
                    Text("Complex")
                        .font(.system(size: 20))
                }).padding()
            }
            
        }
        .padding()
    }
}

//
//  StackSample.swift
//  PackageReference
//
//  Created by Mark Dubouzet on 10/30/24.
//

import Foundation
import SwiftUI

struct StackSample: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing, content: {
            /*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
//            Text("Kimbo")
//            Text("Limbo")
        })
    }
}


// MARK: - Preview
struct StackSample_Previews: PreviewProvider {
    static var previews: some View {
        StackSample()
    }
}

//
//  AvailabilityView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/1/25.
//

import SwiftUI

struct AvailabilityView: View {
    
    @Binding var intakeForm: IntakeForm
    @Binding var path: NavigationPath
    
    var body: some View {
        Text("Availability View")
        
        
        Button(action: {
            path.append("AuthView")
        }){
            Text("Continue")
        }
    }
}

#Preview {
   
}

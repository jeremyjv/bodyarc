//
//  BackInstructionsView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/26/25.
//

import SwiftUI

struct BackInstructionsView: View {
    @Binding var path: NavigationPath
    
    
    var body: some View {
        Text("Back Instructions View")
        
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Bad Photos")
                HStack {
                    Text("pic 1")
                    Text("pic 2")
                    Text("pic 3")
                }
                VStack {
                    Text("Note 1")
                    Text("Note 2")
                    Text("Note 3")
                }
            }
            
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Good Photos")
                HStack {
                    Text("pic 1")
                    Text("pic 2")
                    Text("pic 3")
                }
                VStack {
                    Text("Note 1")
                    Text("Note 2")
                    Text("Note 3")
                }
            }
            CustomScanButton(title: "Continue", path: $path, dest: "BackScanView")
            
            //mark back image as nil and run scan logic here -> redirect to progress view
            CustomScanButton(title: "Skip Back Scan", path: $path, dest: "BackScanView")
        }
    }
}
#Preview {

}

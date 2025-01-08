//
//  RatingView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/6/25.
//

import SwiftUI
import FirebaseFirestore


//we mount analysis data here


struct RatingView: View {
    //attach rating to this view
    @EnvironmentObject var viewModel: ContentViewModel
    @Binding var scanObject: ScanObject
    @State private var frontImage: UIImage? = nil
    @Binding var path: NavigationPath
    
    
    let db = Firestore.firestore()
    
    var body: some View {
        
        //set background to front image darkened
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Group {
            
//            if let image = frontImage {
//                            Image(uiImage: frontImage!)
//                                .resizable()
//                                .scaledToFit()
//                        } else {
//                            
//                            //put a custom progress view
//                            ProgressView() // A loading indicator
//                        }
//            
            //have list of other rating views in tabviewpage
            
            
            
            //every scan will always have a front image
        
        }

    }
}

#Preview {
    
}

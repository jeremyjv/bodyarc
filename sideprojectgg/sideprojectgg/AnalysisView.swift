//
//  AnalysisView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/30/24.
//

import SwiftUI

struct AnalysisView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    
    //want to turn Front and Back analysis from JSON to struct so that we can
    
    //We will eventually embed this view in ScanView, for the user to easily see
    var body: some View {
        ScrollView {
            //display analysis results here
           
            VStack {
                
                //Body Fat Percentage and Overall Muscle Development Rating
                HStack {
                    Text("Estimated BF%: \(viewModel.frontAnalysis?.bodyFatPercentage ?? 0)")
                }
                
                //Upper Body Muscle Ratings
                HStack {
                    
                }
                
                //Lower Body Muscle Ratings
                HStack {
                    
                }
                
                //Muscle Highlights
                HStack {
                    
                }
                
            
                
                
            }
        
            
        }
       
    }
    
}

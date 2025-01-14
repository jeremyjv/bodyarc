//
//  ShoulderRoutineView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 1/10/25.
//

import SwiftUI


// MARK: - ShoulderRoutineView
struct ShoulderRoutineView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    // Title
                    Text("Shoulders")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white) // Title color
                        .padding()

                    // Goal Section
                    SectionView(
                        title: "Goal",
                        content: [
                            SectionContent(
                                text: "Train shoulders with higher volume and intensity to grow the width of the upper body. (Adjust weight and volume accordingly). The key is to progressively overload by adding weight and/or reps each push workout."
                            )
                        ],
                        maxWidth: geometry.size.width * 0.9
                    )

                    // Compound Movements Section
                    SectionView(
                        title: "Compound Movements",
                        content: [
                            SectionContent(
                                text: "Overview",
                                subSections: [
                                    "Growth of the shoulders will primarily come from any compound pressing and pulling movement of the upper body. With compound movements we can overload with heavier weight -- creating the needed stimulus for growth."
                                ]
                            ),
                            SectionContent(
                                text: "Compound Training Styles",
                                subSections: [
                                    "5×5 reps (Heavier Weight)\nStrength Focus",
                                    "3×(8-12) reps (Moderate Weight)\nHypertrophy Focus",
                                    "*Try different styles when you hit plateaus"
                                ]
                            ),
                            SectionContent(
                                text: "Key Shoulder Compounds",
                                subSections: [
                                    "1. Over Head Presses",
                                    "2. Incline Presses",
                                    "3. Bench Presses",
                                    "*Always control the weight to maximize growth and focus on squeezing the muscle. Never use momentum"
                                ]
                            )
                        ],
                        maxWidth: geometry.size.width * 0.9
                    )

                    // Accessory Movements Section
                    SectionView(
                        title: "Accessory Movements",
                        content: [
                            SectionContent(
                                text: "Overview",
                                subSections: [
                                    "Utilize Accessory movements to isolate and drive blood flow into the shoulder muscle. Train Hard."
                                ]
                            ),
                            SectionContent(
                                text: "Accessory Training Styles",
                                subSections: [
                                    "Straight Sets (Normal Sets)\nX Reps → Rest 3 Min",
                                    "Rest Pause Sets\nX Reps → 10s Rest → 0.5X Reps",
                                    "Drop Sets\nX Reps at Y Weight → Rest\nX Reps at",
                                    "Failure + Partial Sets\nFailure with full range of motion → Failure with partial range of motion",
                                    "*Try different styles when you hit plateaus"
                                ]
                            ),
                            SectionContent(
                                text: "Key Shoulder Accessories",
                                subSections: [
                                    "1. Dumbbell/Cable Lateral Raises",
                                    "2. Rear Delt Flies",
                                    "*Always control the weight to maximize growth and focus on squeezing the muscle. Never use momentum"
                                ]
                            )
                        ],
                        maxWidth: geometry.size.width * 0.9
                    )
                }
                .frame(maxWidth: .infinity) // Center-align the content
                .padding()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Background color black
    }
}

// MARK: - SectionView
struct SectionView: View {
    var title: String
    var content: [SectionContent]
    var maxWidth: CGFloat
    var borderColor: Color = .gray
    var titleFont: Font = .title
    var titleColor: Color = .white
    var bodyFont: Font = .body // Font for the main body text
    var bodyTextColor: Color = .gray // Color for body text
    var subsectionFont: Font = .title2 // Font for subsection titles
    var subsectionColor: Color = .white // Color for subsection titles
    var cornerRadius: CGFloat = 10
    var borderWidth: CGFloat = 2

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Title
            Text(title)
                .font(titleFont)
                .foregroundColor(titleColor)
                .fontWeight(.bold) // Make the title bold
                .frame(maxWidth: .infinity, alignment: .center)

            // Content
            ForEach(content, id: \.id) { section in
                // If there are no subsections, treat it as a body text
                if section.subSections == nil {
                    Text(section.text)
                        .font(bodyFont)
                        .foregroundColor(bodyTextColor)
                } else {
                    // Render subsections with their styling
                    SubSectionView(
                        content: section,
                        titleFont: subsectionFont,
                        titleColor: subsectionColor,
                        bulletTextFont: bodyFont,
                        bulletTextColor: bodyTextColor
                    )
                }
            }
        }
        .padding()
        .frame(maxWidth: maxWidth)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        )
    }
}

// MARK: - SubSectionView
struct SubSectionView: View {
    var content: SectionContent
    var titleFont: Font = .title2 // Larger font for subsection titles
    var titleColor: Color = .white // White color for subsection titles
    var bulletTextFont: Font = .body // Font size for bullet points
    var bulletTextColor: Color = .gray // Color for bullet points
    var borderColor: Color = .gray
    var cornerRadius: CGFloat = 8
    var borderWidth: CGFloat = 1

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Subsection Title
            Text(content.text)
                .font(titleFont) // Larger font for the subsection title
                .foregroundColor(titleColor) // White color for the title
                .frame(maxWidth: .infinity, alignment: .leading) // Left-aligned title

            // Subsections (text only, no bullet points)
            if let subSections = content.subSections {
                ForEach(subSections, id: \.self) { text in
                    Text(text) // No bullet points
                        .font(bulletTextFont) // Font for the text
                        .foregroundColor(bulletTextColor) // Gray color for the text
                        .padding(.leading, 0) // Match the title's starting point
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        )
    }
}

// MARK: - SectionContent
struct SectionContent: Identifiable {
    let id = UUID()
    let text: String
    let subSections: [String]?

    init(text: String, subSections: [String]? = nil) {
        self.text = text
        self.subSections = subSections
    }
}

#Preview {

}

//
//  CodeLibrary.swift
//  MyBaliApp
//
//  Created by Ivan on 03/03/26.
//
// Common UI patterns you can copy and paste into your screens
//
// HOW TO USE:
// 1. Find a pattern you like below
// 2. Copy only the code inside the body.
// 3. Paste it into Screen1View or Screen2View
// 4. Customize the text, colors, and icons to match your app
import SwiftUI
// MARK: - PART 1 Pattern
// MARK: - List with rows
struct ListPattern: View {
    var body: some View {
        List {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("First item")
            }
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Second item")
            }
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Third item")
            }
        }
    }
}

// MARK: - Card with content
struct CardPattern: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "photo")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("Card Title")
                .font(.title2)
                .bold()

            Text("Description text goes here")
                .font(.body)
                .foregroundColor(.secondary)

            Button("Action Button") {
                // Action will be added later
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

// MARK: - Form with inputs
struct FormPattern: View {
    @State private var title = ""
    @State private var description = ""
    @State private var notificationsOn = false
    @State private var category = "Work"

    var body: some View {
        Form {
            Section("Details") {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
            }

            Section("Options") {
                Toggle("Enable notifications", isOn: $notificationsOn)
                Picker("Category", selection: $category) {
                    Text("Work").tag("Work")
                    Text("Personal").tag("Personal")
                }
            }
        }
    }
}

// MARK: - Search bar with list
struct SearchPattern: View {
    @State private var searchText = ""

    var body: some View {
        VStack {
            TextField("Search...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            List {
                Text("Search result 1")
                Text("Search result 2")
                Text("Search result 3")
            }
        }
    }
}

// MARK: - PART 2 Layout
// MARK: - ZStack
struct ZStackOverlayExample: View {
    var body: some View {
        // Text over a colored background (like a banner)
        ZStack(alignment: .bottomLeading) {
            // Background
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)

            // Text overlay
            VStack(alignment: .leading) {
                Text("Featured")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.white.opacity(0.8))
                Text("Explore SwiftUI")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
            }
            .padding()
        }
        .padding()
    }
}

// MARK: - Spacer & Alignment
struct SpacerExample: View {
    var body: some View {
        VStack(spacing: 20) {
            // Spacer pushes content apart
            HStack {
                Text("Left")
                Spacer()
                Text("Right")
            }
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(8)

            // Spacer pushes content to one side
            HStack {
                Spacer()
                Text("Pushed Right")
            }
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(8)

            // Frame alignment
            Text("Top-Leading")
                .frame(maxWidth: .infinity, maxHeight: 80, alignment: .topLeading)
                .padding(8)
                .background(.blue.opacity(0.1))
                .cornerRadius(8)

            Text("Center")
                .frame(maxWidth: .infinity, maxHeight: 80, alignment: .center)
                .padding(8)
                .background(.green.opacity(0.1))
                .cornerRadius(8)

            Text("Bottom-Trailing")
                .frame(maxWidth: .infinity, maxHeight: 80, alignment: .bottomTrailing)
                .padding(8)
                .background(.orange.opacity(0.1))
                .cornerRadius(8)
        }
        .padding()
    }
}

// MARK: - Vertical ScrollView
struct VerticalScrollExample: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(1...10, id: \.self) { number in
                    HStack {
                        Image(systemName: "\(number).circle.fill")
                            .font(.title)
                            .foregroundStyle(.blue)
                        Text("Item \(number)")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.gray)
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
    }
}

// MARK: - Horizontal ScrollView
struct HorizontalScrollExample: View {
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Horizontal Scroll")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(colors, id: \.self) { color in
                        VStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(color.gradient)
                                .frame(width: 120, height: 160)

                            Text(color.description.capitalized)
                                .font(.caption)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Grid (Photo Gallery Style)
struct GridExample: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    let icons = [
        "star.fill", "heart.fill", "bolt.fill",
        "leaf.fill", "flame.fill", "drop.fill",
        "moon.fill", "sun.max.fill", "cloud.fill"
    ]

    let colors: [Color] = [
        .red, .pink, .yellow,
        .green, .orange, .blue,
        .purple, .orange, .gray
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<icons.count, id: \.self) { index in
                    VStack {
                        Image(systemName: icons[index])
                            .font(.system(size: 30))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                            .background(colors[index].gradient)
                            .cornerRadius(12)

                        Text(icons[index])
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Two Column Grid (Photo Gallery Style)
struct TwoColumnGridExample: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(1...6, id: \.self) { number in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.blue.opacity(0.2))
                            .frame(height: 120)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundStyle(.blue.opacity(0.5))
                            )

                        Text("Photo \(number)")
                            .font(.caption)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - PART 3 Style
// MARK: - Shapes & Corners
struct ShapesExample: View {
    var body: some View {
        VStack(spacing: 20) {
            // Circle
            Circle()
                .fill(.blue)
                .frame(width: 80, height: 80)

            // Capsule (pill shape)
            Capsule()
                .fill(.green)
                .frame(width: 160, height: 50)

            // Rounded rectangle with custom corner radius
            RoundedRectangle(cornerRadius: 20)
                .fill(.orange)
                .frame(width: 160, height: 80)

            // Rectangle with only some corners rounded
            UnevenRoundedRectangle(
                topLeadingRadius: 20,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 20,
                topTrailingRadius: 0
            )
            .fill(.purple)
            .frame(width: 160, height: 80)
        }
        .padding()
    }
}

// MARK: - Clip Shape
struct ClipShapeExample: View {
    var body: some View {
        VStack(spacing: 20) {
            // Clip an image to a circle
            Image(systemName: "person.fill")
                .font(.system(size: 40))
                .foregroundStyle(.white)
                .frame(width: 80, height: 80)
                .background(.blue)
                .clipShape(Circle())

            // Clip to a capsule
            Text("Capsule Button")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(.pink)
                .clipShape(Capsule())

            // Clip to a rounded rectangle
            Text("Rounded Card")
                .font(.headline)
                .frame(width: 200, height: 80)
                .background(.mint)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding()
    }
}

// MARK: - Border
struct BordersExample: View {
    var body: some View {
        VStack(spacing: 20) {
            // Stroke border on a shape
            RoundedRectangle(cornerRadius: 12)
                .stroke(.blue, lineWidth: 2)
                .frame(width: 200, height: 60)
                .overlay(Text("Stroke Border"))

            // Dashed border
            RoundedRectangle(cornerRadius: 12)
                .stroke(.orange, style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                .frame(width: 200, height: 60)
                .overlay(Text("Dashed Border"))

            // Fill + border using overlay
            Text("Fill + Border")
                .frame(width: 200, height: 60)
                .background(.yellow.opacity(0.3))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.yellow, lineWidth: 2)
                )
        }
        .padding()
    }
}

// MARK: - Backgrounds
struct BackgroundsExample: View {
    var body: some View {
        VStack(spacing: 20) {
            // Color background
            Text("Color Background")
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .cornerRadius(8)

            // Shape background
            Text("Shape Background")
                .padding()
                .background(
                    Capsule()
                        .fill(.green.opacity(0.3))
                )

            // Layered backgrounds
            Text("Layered")
                .font(.headline)
                .foregroundStyle(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [.indigo, .purple],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                )
                .shadow(color: .purple.opacity(0.4), radius: 8, y: 4)

            // Material background (frosted glass)
            Text("Material / Glass")
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
        }
        .padding()
    }
}

// MARK: - Opacity & Blur
struct OpacityExample: View {
    var body: some View {
        VStack(spacing: 20) {
            // Different opacity levels
            HStack(spacing: 12) {
                Circle().fill(.blue).frame(width: 50, height: 50)
                    .opacity(1.0)
                Circle().fill(.blue).frame(width: 50, height: 50)
                    .opacity(0.7)
                Circle().fill(.blue).frame(width: 50, height: 50)
                    .opacity(0.4)
                Circle().fill(.blue).frame(width: 50, height: 50)
                    .opacity(0.1)
            }

            // Layered transparency
            ZStack {
                Circle().fill(.red).frame(width: 100, height: 100)
                    .offset(x: -25)
                Circle().fill(.blue).frame(width: 100, height: 100)
                    .offset(x: 25)
                    .opacity(0.5)
            }
        }
        .padding()
    }
}

// MARK: - Previews Part 1 (Pattern)
#Preview("List Pattern") {
    ListPattern()
}

#Preview("Card With Content") {
    CardPattern()
}

#Preview("Form Pattern") {
    FormPattern()
}

#Preview("Search Pattern") {
    SearchPattern()
}

// MARK: - Previews Part 2 (Layout)
#Preview("ZStack Example") {
    ZStackOverlayExample()
}

#Preview("Spacer Example") {
    SpacerExample()
}

#Preview("Vertical Scroll Example") {
    VerticalScrollExample()
}

#Preview("Horizontal Scroll Example") {
    HorizontalScrollExample()
}

#Preview("Grid Example") {
    GridExample()
}

#Preview("Two Column Grid") {
    TwoColumnGridExample()
}

// MARK: - Previews Part 3 (Style)
#Preview("Shapes Example") {
    ShapesExample()
}

#Preview("Clip Shape Example") {
    ClipShapeExample()
}

#Preview("Borders Example") {
    BordersExample()
}

#Preview("Backgrounds Example") {
    BackgroundsExample()
}

#Preview("Opacity Example") {
    OpacityExample()
}







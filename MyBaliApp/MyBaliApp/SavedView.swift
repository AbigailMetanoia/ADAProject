import SwiftUI

struct SavedView: View {

    @State private var savedKos: [Kos] = []

    var body: some View {

        NavigationStack {

            VStack {

                Text("Saved Kos")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                if savedKos.isEmpty {

                    VStack(spacing: 12) {

                        Image(systemName: "bookmark.slash")
                            .font(.largeTitle)

                        Text("No saved kos yet")
                            .foregroundColor(.secondary)

                    }
                    .frame(maxHeight: .infinity, alignment: .center)

                } else {

                    ScrollView {

                        VStack(spacing: 12) {

                            ForEach(savedKos) { kos in

                                NavigationLink {
                                    Screen2View(kos: kos)
                                } label: {

                                    KosCard(
                                        image: kos.image,
                                        title: kos.title,
                                        distance: "\(kos.distance)m from Academy",
                                        price: "\(kos.price) mio / month",
                                        info: "\(kos.gender) - \(kos.facilities)"
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {

            let defaults = UserDefaults.standard

            let savedTitles = defaults.stringArray(forKey: "savedKos") ?? []

            savedKos = kosList.filter { savedTitles.contains($0.title) }

        }
    }
}
struct KosCard: View {
    
    var image: String
    var title: String
    var distance: String
    var price: String
    var info: String
    
    var body: some View {
        
        HStack(spacing: 5) {
            
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 150)
                .clipped()
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 20,
                        bottomLeadingRadius: 20
                    )
                )

            VStack(alignment: .leading, spacing: 12) {
                
                Text(title)
                    .font(.title3)
                    .foregroundColor(.primary)
                    .bold()
                
                HStack(spacing: 5) {
                    Image(systemName: "figure.walk")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Text(distance)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.gray.opacity(0.2))
                .clipShape(Capsule())
                
                Text(price)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.primary)
                
                Text(info)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .padding()
        }
        .frame(height: 150)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
        .shadow(radius: 4)
    }
}

#Preview {
    SavedView()
}

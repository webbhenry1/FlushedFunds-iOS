import SwiftUI

struct FinishedView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            Color(red: 8 / 255.0, green: 89 / 255.0, blue: 72 / 255.0) // Set the background color
                .ignoresSafeArea(.all)

            VStack {
                Text(summaryText)
                    .font(.title)
                    .foregroundColor(.white)
                
                CustomListCell(title: "Total Pool", value: "$\(gameViewModel.totalPool)")
                CustomListCell(title: "Biggest $ Gain", value: gameViewModel.biggestWinner?.name ?? "-")
                CustomListCell(title: "Biggest $ Loss", value: gameViewModel.biggestLoser?.name ?? "-")
                CustomListCell(title: "Biggest % Gain", value: gameViewModel.biggestPercentageGain?.name ?? "-")
                CustomListCell(title: "Biggest % Loss", value: gameViewModel.biggestPercentageLoss?.name ?? "-")


                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
        }
    }

    var summaryText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        return (hour >= 12 ? "Tonight's" : "Today's") + " Summary"
    }
}

struct CustomListCell: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}

struct FinishedView_Previews: PreviewProvider {
    static var previews: some View {
        FinishedView()
            .environmentObject(GameViewModel())
    }
}

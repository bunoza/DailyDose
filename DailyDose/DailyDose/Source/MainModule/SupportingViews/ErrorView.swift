import Lottie
import SwiftUI

struct ErrorView: View {
    private var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        VStack {
            Spacer()
            LottieView(name: "error-animation", loopMode: .playOnce)
                .frame(width: 400, height: 200)
                .aspectRatio(contentMode: .fit)
            Text("An error occurred. Please try again.")
                .foregroundStyle(Color.gray)
            Spacer()
            Button {
                action()
            } label: {
                Text("Try again")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding(4)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ErrorView(action: {})
}

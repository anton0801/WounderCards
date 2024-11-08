import SwiftUI

struct InfoPasiansGameView: View {
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                Image("girl")
                    .resizable()
                    .frame(width: 200, height: 240)
            }
            Spacer()
            Image("info_content")
                .resizable()
                .frame(width: 550, height: 350)
            Spacer()
            VStack {
                Button {
                    NotificationCenter.default.post(name: Notification.Name("CLOSE_INFO"), object: nil)
                } label: {
                    Image("close")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                Spacer()
            }
            .padding(.top)
        }
        .ignoresSafeArea()
        .background(
            Rectangle()
                .fill(.black)
                .opacity(0.4)
                .ignoresSafeArea()
        )
    }
    
}

#Preview {
    InfoPasiansGameView()
}

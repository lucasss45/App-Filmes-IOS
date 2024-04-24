//
//
//

import Foundation
// Função para gerar dados mockados da série "The Last of Us"
func gerarBreakingBad() -> Series {
    return Series(
        id: "tt0903747",
        title: "Breaking Bad",
        genre: "Drama, Crime, Suspense",
        season: 3,
        episode: 2,
        released: "20/01/2008",
        language: "Inglês",
        country: "Estados Unidos",
        plot: "Um professor de química do ensino médio desiludido se transforma em um traficante de drogas para garantir o futuro de sua família após ser diagnosticado com câncer terminal.",
        posterURL: "https://example.com/poster-breaking-bad.jpg",
        isFavorite: false
    )
}

// Função para gerar dados mockados da série "La Casa de Papel"
func gerarLaCasaDePapel() -> Series {
    return Series(
        id: "tt6468322",
        title: "La Casa de Papel",
        genre: "Drama, Crime, Mistério",
        season: 4,
        episode: 4,
        released: "02/05/2017",
        language: "Espanhol",
        country: "Espanha",
        plot: "Um grupo de criminosos planeja e executa o roubo mais ousado da história: imprimir 2,4 bilhões de euros na Casa da Moeda da Espanha.",
        posterURL: "https://example.com/poster-la-casa-de-papel.jpg",
        isFavorite: false
    )
}

func gerarTheLastOfUs() -> Series {
    return Series(
        id: "tt2235759",
        title: "The Last of Us",
        genre: "Ação, Aventura, Drama",
        season: 1,
        episode: 5,
        released: "19/06/2024",
        language: "Inglês",
        country: "Estados Unidos",
        plot: "Em um mundo pós-apocalíptico, um homem durão, que tem como tarefa proteger uma jovem garota imune a uma praga mortal, forma um vínculo comovente com ela enquanto lutam pela sobrevivência.",
        posterURL: "https://example.com/poster-the-last-of-us.jpg",
        isFavorite: false
    )
}


// Exemplo executar a funçao
//let breakingBad = gerarBreakingBad()
////print(breakingBad)
//
//let laCasaDePapel = gerarLaCasaDePapel()
////print(laCasaDePapel)

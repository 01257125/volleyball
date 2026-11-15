import SwiftUI
import Foundation

// MARK: - 資料模型

/// 學校枚舉
enum School: String, CaseIterable, Identifiable, Codable {
    case karasuno = "烏野高中"
    case nekoma = "音駒高中"
    case aobaJohsai = "青葉城西高中"
    case fukurodani = "梟谷學園高中"
    case inarizaki = "稻荷崎高中"
    case shiratorizawa = "白鳥澤學園高中"

    var id: String { rawValue }

    var motto: String {
        switch self {
        case .karasuno: return "飛吧（飛べ）"
        case .nekoma: return "連接（繋げ）"
        case .aobaJohsai: return "稱霸球場（コートを制す）"
        case .fukurodani: return "一球入魂（一球入魂）"
        case .inarizaki: return "無需回憶昨日（思い出なんかいらん）"
        case .shiratorizawa: return "強者恆強（強者であれ）"
        }
    }

    var mascot: String {
        switch self {
        case .karasuno: return "烏鴉 🦅"
        case .nekoma: return "野貓 🐈"
        case .aobaJohsai: return "青葉 🌿"
        case .fukurodani: return "貓頭鷹 🦉"
        case .inarizaki: return "狐狸 🦊"
        case .shiratorizawa: return "白鷲 🦅"
        }
    }

    var themeColor: Color {
        switch self {
        case .karasuno: return Color.orange
        case .nekoma: return Color.red
        case .aobaJohsai: return Color.teal
        case .fukurodani: return Color.yellow
        case .inarizaki: return Color.purple
        case .shiratorizawa: return Color(red: 0.5, green: 0.1, blue: 0.4)
        }
    }
}

/// 排球場上守備位置
enum Position: String, CaseIterable, Identifiable, Codable {
    case middleBlocker = "副攻手 (MB)"
    case outsideHitter = "主攻手 (OH / WS)"
    case setter = "舉球員 (S)"
    case oppositeHitter = "副攻手 / 接應 (OP)"
    case libero = "自由球員 (L)"

    var id: String { rawValue }

    var shortName: String {
        switch self {
        case .middleBlocker: return "MB"
        case .outsideHitter: return "OH"
        case .setter: return "S"
        case .oppositeHitter: return "OP"
        case .libero: return "L"
        }
    }
}

/// 球員六維能力數值 (滿分 5 分)
struct PlayerStats: Hashable, Codable {
    let power: Int
    let jumping: Int
    let stamina: Int
    let technique: Int
    let speed: Int
    let intelligence: Int
}

/// 球員資料模型
struct Player: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let japaneseName: String
    let number: Int
    let school: School
    let position: Position
    let height: Double
    let quote: String
    let signatureMove: String
    let biography: String
    let matchHighlight: String // 排球經典名場面紀實描述
    let avatarURL: String
    let bannerURL: String
    let wikiURL: String
    let videoURL: String
    let stats: PlayerStats
}

/// 賽事記錄模型
struct MatchRecord: Identifiable, Hashable {
    let id = UUID()
    let roundTitle: String
    let opponentSchool: String
    let opponentRomaji: String
    let score: String
    let result: String
    let highlightSummary: String
    let isVictory: Bool
}

/// 賽事組別
struct TournamentSection: Identifiable {
    let id = UUID()
    let tournamentName: String
    let season: String
    let matches: [MatchRecord]
}

/// 照片牆資料模型
struct GalleryPhoto: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageURL: String
}

// MARK: - 資料集
enum MockData {
    static let players: [Player] = [
        Player(
            name: "日向 翔陽",
            japaneseName: "ひなた しょうよう (Hinata Shoyo)",
            number: 10,
            school: .karasuno,
            position: .middleBlocker,
            height: 164.2,
            quote: "眼前這道很高很高的牆，牆的另一頭是怎樣的風景呢？",
            signatureMove: "超速怪人快攻、頂級誘餌、廣角扣球、衝刺起跳",
            biography: "烏野高中的最強誘餌。身材嬌小卻具備驚人的彈跳力與反應神經，與影山飛雄的『怪人快攻』成為春高賽場上最令人矚目的進攻組合。",
            matchHighlight: "【烏野 vs 青葉城西・決勝局】\n面對及川與青城嚴密的雙人攔網，日向在最後一刻並未避讓，而是大膽以大幅度跨步起跳，在空中打出極限超斜線扣球！排球擦過攔網手邊緣重重砸進界內，成功跨越青城高牆，宣告烏野『最強誘餌』的全新進化。",
            avatarURL: "https://static.wikia.nocookie.net/haikyuu/images/d/d2/Hinata_s4-e1-4.png",
            bannerURL: "https://static.wikia.nocookie.net/haikyuu/images/2/2c/Season_1_Poster.jpg",
            wikiURL: "https://zh.wikipedia.org/wiki/%E6%8E%92%E7%90%83%E5%B0%91%E5%B9%B4%EF%BC%81%EF%BC%81",
            videoURL: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
            stats: PlayerStats(power: 2, jumping: 5, stamina: 5, technique: 2, speed: 5, intelligence: 2)
        ),
        Player(
            name: "影山 飛雄",
            japaneseName: "かげやま とびお (Kageyama Tobio)",
            number: 9,
            school: .karasuno,
            position: .setter,
            height: 181.9,
            quote: "能留在球場上的人，只有贏家跟最強的傢伙。想留下來的話就給我變強！",
            signatureMove: "精密制導托球、強力跳躍發球、二次進攻、怪人快攻",
            biography: "被稱為『球場上的王者』的天才舉球員。控球精確度近乎極致，在烏野逐漸體會團隊的意義，與日向建立起無可替代的默契信任。",
            matchHighlight: "【烏野 vs 白鳥澤・賽末點】\n在全場體能逼近極限的第五局，影山依然以近乎機械般的冷靜精確度送出零容錯托球。在烏野全員五人同步起跳的瞬間，影山將球分毫不差地送至最佳擊球點，以完美策動助球隊拿下歷史性勝利。",
            avatarURL: "https://static.wikia.nocookie.net/haikyuu/images/e/e7/Kageyama_s4-e7-3.png",
            bannerURL: "https://static.wikia.nocookie.net/haikyuu/images/a/a5/Karasuno_Team.png",
            wikiURL: "https://zh.wikipedia.org/wiki/%E6%8E%92%E7%90%83%E5%B0%91%E5%B9%B4%EF%BC%81%EF%BC%81",
            videoURL: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
            stats: PlayerStats(power: 4, jumping: 4, stamina: 5, technique: 5, speed: 4, intelligence: 5)
        ),
        Player(
            name: "月島 螢",
            japaneseName: "つきしま けい (Tsukishima Kei)",
            number: 11,
            school: .karasuno,
            position: .middleBlocker,
            height: 190.1,
            quote: "只不過是攔下一球，只不過是25分中的一分…但如果那一刻到來，那就是你迷上排球的瞬間！",
            signatureMove: "理性閱讀攔網 (Read Block)、滯空吊球、單人關鍵封阻",
            biography: "烏野高中的理性司令塔與最高防線。冷靜沉著、長於觀察，在白鳥澤一役以攔死牛島的精彩表現徹底覺醒。",
            matchHighlight: "【烏野 vs 白鳥澤・第二局局末】\n面對全國前三王牌牛島若利的霸道重扣，月島整整觀察了兩局牛島的手腕微動與球路習慣，在關鍵分精準起跳、極限下壓，以單人攔網將牛島的重砲扣殺硬生生封死！月島握拳仰天長嘯，成為點燃全場士氣的封神時刻。",
            avatarURL: "https://static.wikia.nocookie.net/haikyuu/images/7/73/Tsukishima_s4-e6-2.png",
            bannerURL: "https://static.wikia.nocookie.net/haikyuu/images/3/37/Season_3_Poster.jpg",
            wikiURL: "https://zh.wikipedia.org/wiki/%E6%8E%92%E7%90%83%E5%B0%91%E5%B9%B4%EF%BC%81%EF%BC%81",
            videoURL: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
            stats: PlayerStats(power: 2, jumping: 3, stamina: 3, technique: 4, speed: 3, intelligence: 5)
        ),
        Player(
            name: "西谷 夕",
            japaneseName: "にしのや ゆう (Nishinoya Yu)",
            number: 4,
            school: .karasuno,
            position: .libero,
            height: 160.5,
            quote: "只要球還沒有落地，就絕不認輸！就算背後是萬丈深淵，我的身後也永遠有大家！",
            signatureMove: "滾動雷霆 (Rolling Thunder)、跳躍下手舉球、腳背接球",
            biography: "『烏野的守護神』。球風剛猛敏捷，是烏野場上最令人安心的防守基石與精神支柱。",
            matchHighlight: "【烏野 vs 稻荷崎・關鍵接球】\n面對全日本第一舉球員宮侑的致命二刀流跳飄球，西谷在被連續針對後迅速調整重心與步法，以極致果斷的上手接球完美化解危機，穩穩將球送至三米線前，化身球場最後方最堅不可摧的守護神。",
            avatarURL: "https://static.wikia.nocookie.net/haikyuu/images/d/db/Nishinoya_2_s1_e20.png",
            bannerURL: "https://static.wikia.nocookie.net/haikyuu/images/3/3a/Season_2_Poster.jpg",
            wikiURL: "https://zh.wikipedia.org/wiki/%E6%8E%92%E7%90%83%E5%B0%91%E5%B9%B4%EF%BC%81%EF%BC%81",
            videoURL: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
            stats: PlayerStats(power: 2, jumping: 4, stamina: 5, technique: 4, speed: 5, intelligence: 4)
        ),
        Player(
            name: "孤爪 研磨",
            japaneseName: "こづめ けんま (Kozume Kenma)",
            number: 5,
            school: .nekoma,
            position: .setter,
            height: 169.2,
            quote: "如果不把遊戲通關的話，不是會覺得很不爽嗎？",
            signatureMove: "視線誘導、視差假動作托球、精確戰術佈局",
            biography: "音駒高中的『大腦』與『心臟』。具備極致的洞察力與預判能力，擅長冷靜分析並瓦解對手節奏。",
            matchHighlight: "【音駒 vs 烏野・垃圾場的決戰】\n研磨運用縝密的戰術佈局，透過連續落點控制徹底封鎖日向的助跑直線距離，將烏野的王牌快攻一步步困入『籠中』。整場比賽展現出頂級大腦的戰術思維，打出了一場沒有『再來一次』的宿命大戰。",
            avatarURL: "https://static.wikia.nocookie.net/haikyuu/images/8/80/Land_VS_Air_-_Kenma.jpg",
            bannerURL: "https://static.wikia.nocookie.net/haikyuu/images/f/f8/Decisive_Battle_at_the_Garbage_Dump_2.jpeg",
            wikiURL: "https://zh.wikipedia.org/wiki/%E6%8E%92%E7%90%83%E5%B0%91%E5%B9%B4%EF%BC%81%EF%BC%81",
            videoURL: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
            stats: PlayerStats(power: 1, jumping: 2, stamina: 2, technique: 5, speed: 3, intelligence: 5)
        ),
        Player(
            name: "黑尾 鐵朗",
            japaneseName: "くろお てつろう (Kuroo Tetsuro)",
            number: 1,
            school: .nekoma,
            position: .middleBlocker,
            height: 187.7,
            quote: "我們是血液，要順暢地流動，輸送氧氣，讓『心臟』維持運作！",
            signatureMove: "個人引導攔網、時間差進攻、強攻破防",
            biography: "音駒高中排球部主將。擅長掌控攔網時機的防守專家，具備出色的接球與領導能力。",
            matchHighlight: "【音駒 vs 梟谷・東京代表戰】\n黑尾以老練的個人引導攔網（Lead Block）完美限制木兔的扣球角度，並在關鍵分發動神速時間差進攻得分。防守時如血液般流暢補位，展現出全國頂級副攻手的統率力。",
            avatarURL: "https://static.wikia.nocookie.net/haikyuu/images/7/7a/Kuroo_OVA.jpg",
            bannerURL: "https://static.wikia.nocookie.net/haikyuu/images/b/b1/Nekoma_Season_2.png",
            wikiURL: "https://zh.wikipedia.org/wiki/%E6%8E%92%E7%90%83%E5%B0%91%E5%B9%B4%EF%BC%81%EF%BC%81",
            videoURL: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
            stats: PlayerStats(power: 3, jumping: 4, stamina: 4, technique: 4, speed: 4, intelligence: 4)
        ),
        Player(
            name: "及川 徹",
            japaneseName: "おいかわ とおる (Oikawa Toru)",
            number: 1,
            school: .aobaJohsai,
            position: .setter,
            height: 184.3,
            quote: "才能是可以讓其開花結果的，球感是可以磨礪出來的！",
            signatureMove: "重砲跳躍發球、百分之百發揮隊友潛力之托球",
            biography: "青葉城西排球部隊長。擁有超強的領袖魅力與洞察力，被稱作能發揮每一位隊友百分之百實力的大王。",
            matchHighlight: "【青葉城西 vs 烏野・準決賽】\n在落後逆境下，及川以時速超過百公里的超重砲跳發連續破壞烏野接球防線，並在場外救球時飛出場外送出一記橫跨全場的超長距離神級托球，將全隊攻手的實力激發至120%。",
            avatarURL: "https://static.wikia.nocookie.net/haikyuu/images/8/88/Oikawa_Season_1_Episode_7.png",
            bannerURL: "https://static.wikia.nocookie.net/haikyuu/images/3/36/AobaJohsai.jpeg",
            wikiURL: "https://zh.wikipedia.org/wiki/%E6%8E%92%E7%90%83%E5%B0%91%E5%B9%B4%EF%BC%81%EF%BC%81",
            videoURL: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
            stats: PlayerStats(power: 4, jumping: 4, stamina: 4, technique: 5, speed: 4, intelligence: 4)
        ),
        Player(
            name: "木兔 光太郎",
            japaneseName: "ぼくと こうたろう (Bokuto Kotaro)",
            number: 4,
            school: .fukurodani,
            position: .outsideHitter,
            height: 185.3,
            quote: "排球就只是單純好玩而已！",
            signatureMove: "極限超斜線扣球、壓線直線球、假扣真吊",
            biography: "梟谷學園的王牌主將，全國前五大王牌攻手之一。球風充滿能量，一旦進入最佳狀態便無人可擋。",
            matchHighlight: "【梟谷 vs 狢坂・全國八強】\n面對全國三大王牌之一的桐生八，木兔徹底打破『消極模式』，全場狀態全開！以不可思議的極限內角直線重扣與大角度斜線扣殺連續轟炸，展現出真正純粹、無可阻擋的世界級王牌風範。",
            avatarURL: "https://static.wikia.nocookie.net/haikyuu/images/0/02/Bokuto_s4-e9-1.png",
            bannerURL: "https://static.wikia.nocookie.net/haikyuu/images/2/22/Land_vs_air_promo.jpg",
            wikiURL: "https://zh.wikipedia.org/wiki/%E6%8E%92%E7%90%83%E5%B0%91%E5%B9%B4%EF%BC%81%EF%BC%81",
            videoURL: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
            stats: PlayerStats(power: 5, jumping: 4, stamina: 5, technique: 4, speed: 4, intelligence: 3)
        ),
        Player(
            name: "宮 侑",
            japaneseName: "みや あつむ (Miya Atsumu)",
            number: 7,
            school: .inarizaki,
            position: .setter,
            height: 183.6,
            quote: "若說給主攻手最舒服托球的人是第一舉球員，那這個人一定就是我！",
            signatureMove: "二刀流發球（跳發／跳飄）、雙胞胎快攻",
            biography: "稻荷崎高中的高中第一舉球員，全日本青年隊代表。球風狂放且充滿冒險精神，享受純粹的進攻樂趣。",
            matchHighlight: "【稻荷崎 vs 烏野・初登場】\n僅憑看過一次日向與影山的怪人快攻，宮侑便在賽場上與雙胞胎弟弟宮治完美複製出『負節奏快攻』，以狂傲的進攻想像力震驚全場，展示了身為高中第一舉球員的絕對技術天賦。",
            avatarURL: "https://static.wikia.nocookie.net/haikyuu/images/3/3c/Atsumu_s4-e1-1.png",
            bannerURL: "https://static.wikia.nocookie.net/haikyuu/images/5/57/Inarizaki_High.PNG",
            wikiURL: "https://zh.wikipedia.org/wiki/%E6%8E%92%E7%90%83%E5%B0%91%E5%B9%B4%EF%BC%81%EF%BC%81",
            videoURL: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
            stats: PlayerStats(power: 4, jumping: 4, stamina: 4, technique: 5, speed: 4, intelligence: 5)
        ),
        Player(
            name: "牛島 若利",
            japaneseName: "うしじま わかとし (Ushijima Wakatoshi)",
            number: 1,
            school: .shiratorizawa,
            position: .oppositeHitter,
            height: 189.5,
            quote: "無論有多艱難，只要把球傳給我，我就會為球隊得分！",
            signatureMove: "左撇子重力扣殺、超重壓跳躍發球",
            biography: "白鳥澤學園絕對王牌，全日本U19代表、全國前三大王牌。以無可撼動的左撇子重扣摧毀對手防線。",
            matchHighlight: "【白鳥澤 vs 烏野・全場統治】\n身為左撇子重砲王牌，牛島整場比賽頂著烏野三名攔網球員與西谷的精準防守，一次次以壓倒性的力量與旋轉重扣轟破攔網，一人狂砍全場最高得分，詮釋了何謂『強者恆強』的絕對力量。",
            avatarURL: "https://static.wikia.nocookie.net/haikyuu/images/d/d5/Ushijima_s4-e3-2.png",
            bannerURL: "https://static.wikia.nocookie.net/haikyuu/images/d/d9/Shiratorizawa_%28anime%29.jpg",
            wikiURL: "https://zh.wikipedia.org/wiki/%E6%8E%92%E7%90%83%E5%B0%91%E5%B9%B4%EF%BC%81%EF%BC%81",
            videoURL: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
            stats: PlayerStats(power: 5, jumping: 4, stamina: 5, technique: 3, speed: 3, intelligence: 4)
        )
    ]

    /// 賽事記錄
    static let tournamentSections: [TournamentSection] = [
        TournamentSection(
            tournamentName: "春季高中排球宮城縣代表賽",
            season: "宮城縣預選決賽",
            matches: [
                MatchRecord(
                    roundTitle: "準決賽（三局兩勝）",
                    opponentSchool: "青葉城西高中",
                    opponentRomaji: "AOBA JOHSAI",
                    score: "2 : 1",
                    result: "烏野勝",
                    highlightSummary: "決勝局日向大膽跨步斜線扣球穿透雙人攔網，烏野成功挺進決賽！",
                    isVictory: true
                ),
                MatchRecord(
                    roundTitle: "冠軍決賽（五局三勝）",
                    opponentSchool: "白鳥澤學園",
                    opponentRomaji: "SHIRATORIZAWA",
                    score: "3 : 2",
                    result: "晉級全國",
                    highlightSummary: "月島攔下牛島重扣，烏野全員五人同步多點進攻拿下致勝分，進軍春高！",
                    isVictory: true
                )
            ]
        ),
        TournamentSection(
            tournamentName: "全日本春季高中排球錦標賽",
            season: "東京體育館・全國大賽",
            matches: [
                MatchRecord(
                    roundTitle: "全國大賽 第一輪",
                    opponentSchool: "椿原學園",
                    opponentRomaji: "TSUBAKIHARA",
                    score: "2 : 0",
                    result: "烏野勝",
                    highlightSummary: "克服全國大賽體育館空間感，日向新扣球姿勢順利開張，旗開得勝。",
                    isVictory: true
                ),
                MatchRecord(
                    roundTitle: "全國大賽 第二輪",
                    opponentSchool: "稻荷崎高中",
                    opponentRomaji: "INARIZAKI",
                    score: "2 : 1",
                    result: "烏野勝",
                    highlightSummary: "日向關鍵高球接球穩住軍心，影山與日向於終盤攔截宮兄弟雙胞胎快攻！",
                    isVictory: true
                ),
                MatchRecord(
                    roundTitle: "全國大賽 第三輪「垃圾場的決戰」",
                    opponentSchool: "音駒高中",
                    opponentRomaji: "NEKOMA",
                    score: "2 : 1",
                    result: "烏野勝",
                    highlightSummary: "跨越數十載宿命對決！球因汗水滑落結束漫長來回，研磨笑著說出『真開心』。",
                    isVictory: true
                )
            ]
        )
    ]

    /// 劇照海報集
    static let galleryPhotos: [GalleryPhoto] = [
        GalleryPhoto(
            title: "垃圾場的決戰",
            subtitle: "烏鴉與野貓的宿命對決",
            imageURL: "https://static.wikia.nocookie.net/haikyuu/images/f/f8/Decisive_Battle_at_the_Garbage_Dump_2.jpeg"
        ),
        GalleryPhoto(
            title: "第一季：頂端的景色",
            subtitle: "日向翔陽與影山飛雄的相遇",
            imageURL: "https://static.wikia.nocookie.net/haikyuu/images/2/2c/Season_1_Poster.jpg"
        ),
        GalleryPhoto(
            title: "第三季：烏野 VS 白鳥澤",
            subtitle: "月島螢關鍵攔網封神之戰",
            imageURL: "https://static.wikia.nocookie.net/haikyuu/images/3/37/Season_3_Poster.jpg"
        ),
        GalleryPhoto(
            title: "烏野高校排球部：飛吧！",
            subtitle: "烏野全員大集合",
            imageURL: "https://static.wikia.nocookie.net/haikyuu/images/a/a5/Karasuno_Team.png"
        ),
        GalleryPhoto(
            title: "第二季：東京遠征合宿",
            subtitle: "音駒、梟谷強者匯聚",
            imageURL: "https://static.wikia.nocookie.net/haikyuu/images/3/3a/Season_2_Poster.jpg"
        ),
        GalleryPhoto(
            title: "OVA：陸 VS 空",
            subtitle: "東京都代表決定戰",
            imageURL: "https://static.wikia.nocookie.net/haikyuu/images/2/22/Land_vs_air_promo.jpg"
        )
    ]
}

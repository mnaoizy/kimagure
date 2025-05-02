package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/joho/godotenv"
	"github.com/langrics/kimagure-server/db"
)

func main() {
	// Load environment variables
	err := godotenv.Load("../../.env")
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	// Connect to database using DATABASE_URL from environment
	connStr := os.Getenv("DATABASE_URL")
	if connStr == "" {
		log.Fatal("DATABASE_URL environment variable is required")
	}

	ctx := context.Background()
	conn, err := pgx.Connect(ctx, connStr)
	if err != nil {
		log.Fatal(fmt.Errorf("failed to connect to database: %w", err))
	}
	defer conn.Close(ctx)

	queries := db.New(conn)

	// Seed lessons
	lessons := []struct {
		title       string
		description string
	}{
		{"📚 基礎漢字", "基本的な漢字の学習"},
		{"💬 日常会話", "日常で使われる中国語表現"},
		{"💼 ビジネス", "ビジネスシーンで使える中国語"},
		{"🧳 旅行", "旅行中に役立つフレーズと単語"},
		{"🍜 食事", "レストランや食事に関する表現"},
		{"🔢 数字と時間", "数字、日付、時間の表現"},
		{"🛒 買い物", "買い物やショッピングに関する表現"},
		{"🚆 交通", "交通手段や道案内に関する表現"},
	}

	for _, lesson := range lessons {
		_, err := queries.CreateLesson(context.Background(), db.CreateLessonParams{
			Title:       lesson.title,
			Description: pgtype.Text{String: lesson.description, Valid: true},
		})
		if err != nil {
			log.Printf("Failed to create lesson %s: %v", lesson.title, err)
		}
	}

	// Seed chinese items
	items := []struct {
		character string
		pinyin    string
		meaning   string
		lessonID  int32
	}{
		// 📚 基礎漢字 (Lesson ID: 1)
		{"你好", "nǐ hǎo", "こんにちは", 1},
		{"谢谢", "xiè xie", "ありがとう", 1},
		{"不客气", "bú kè qi", "どういたしまして", 1},
		{"对不起", "duì bù qǐ", "すみません", 1},
		{"没关系", "méi guān xi", "大丈夫です", 1},
		{"是", "shì", "はい", 1},
		{"不是", "bú shì", "いいえ", 1},
		{"我", "wǒ", "私", 1},
		{"你", "nǐ", "あなた", 1},
		{"他", "tā", "彼", 1},
		{"她", "tā", "彼女", 1},
		{"好", "hǎo", "良い", 1},
		{"大", "dà", "大きい", 1},
		{"小", "xiǎo", "小さい", 1},
		{"多", "duō", "多い", 1},

		// 💬 日常会話 (Lesson ID: 2)
		{"早上好", "zǎo shàng hǎo", "おはよう", 2},
		{"晚上好", "wǎn shàng hǎo", "こんばんは", 2},
		{"再见", "zài jiàn", "さようなら", 2},
		{"请问", "qǐng wèn", "すみません（質問する時）", 2},
		{"我不明白", "wǒ bù míng bái", "わかりません", 2},
		{"请再说一遍", "qǐng zài shuō yī biàn", "もう一度言ってください", 2},
		{"请说慢一点", "qǐng shuō màn yī diǎn", "ゆっくり話してください", 2},
		{"我饿了", "wǒ è le", "お腹がすきました", 2},
		{"我渴了", "wǒ kě le", "喉が渇きました", 2},
		{"我累了", "wǒ lèi le", "疲れました", 2},
		{"今天天气真好", "jīn tiān tiān qì zhēn hǎo", "今日は天気がいいですね", 2},
		{"我很好", "wǒ hěn hǎo", "元気です", 2},
		{"认识你很高兴", "rèn shi nǐ hěn gāo xìng", "お会いできて嬉しいです", 2},
		{"我听不懂", "wǒ tīng bù dǒng", "聞き取れません", 2},
		{"没问题", "méi wèn tí", "問題ありません", 2},

		// 💼 ビジネス (Lesson ID: 3)
		{"合同", "hé tong", "契約書", 3},
		{"会议", "huì yì", "会議", 3},
		{"公司", "gōng sī", "会社", 3},
		{"老板", "lǎo bǎn", "社長", 3},
		{"同事", "tóng shì", "同僚", 3},
		{"客户", "kè hù", "顧客", 3},
		{"营业部", "yíng yè bù", "営業部", 3},
		{"人事部", "rén shì bù", "人事部", 3},
		{"报告", "bào gào", "レポート", 3},
		{"项目", "xiàng mù", "プロジェクト", 3},
		{"签名", "qiān míng", "署名", 3},
		{"决定", "jué dìng", "決定", 3},
		{"预算", "yù suàn", "予算", 3},
		{"会议室", "huì yì shì", "会議室", 3},
		{"名片", "míng piàn", "名刺", 3},

		// 🧳 旅行 (Lesson ID: 4)
		{"护照", "hù zhào", "パスポート", 4},
		{"签证", "qiān zhèng", "ビザ", 4},
		{"机场", "jī chǎng", "空港", 4},
		{"航班", "háng bān", "フライト", 4},
		{"酒店", "jiǔ diàn", "ホテル", 4},
		{"行李", "xíng li", "荷物", 4},
		{"景点", "jǐng diǎn", "観光スポット", 4},
		{"地图", "dì tú", "地図", 4},
		{"照片", "zhào piàn", "写真", 4},
		{"纪念品", "jì niàn pǐn", "お土産", 4},
		{"入住", "rù zhù", "チェックイン", 4},
		{"退房", "tuì fáng", "チェックアウト", 4},
		{"我迷路了", "wǒ mí lù le", "道に迷いました", 4},
		{"厕所在哪里", "cè suǒ zài nǎ lǐ", "トイレはどこですか", 4},
		{"这个多少钱", "zhè ge duō shǎo qián", "これはいくらですか", 4},

		// 🍜 食事 (Lesson ID: 5)
		{"餐厅", "cān tīng", "レストラン", 5},
		{"菜单", "cài dān", "メニュー", 5},
		{"服务员", "fú wù yuán", "ウェイター/ウェイトレス", 5},
		{"筷子", "kuài zi", "箸", 5},
		{"碗", "wǎn", "茶碗", 5},
		{"盘子", "pán zi", "皿", 5},
		{"杯子", "bēi zi", "コップ", 5},
		{"米饭", "mǐ fàn", "ご飯", 5},
		{"面条", "miàn tiáo", "麺", 5},
		{"饺子", "jiǎo zi", "餃子", 5},
		{"火锅", "huǒ guō", "火鍋", 5},
		{"茶", "chá", "お茶", 5},
		{"啤酒", "pí jiǔ", "ビール", 5},
		{"好吃", "hǎo chī", "美味しい", 5},
		{"辣", "là", "辛い", 5},

		// 🔢 数字と時間 (Lesson ID: 6)
		{"零", "líng", "ゼロ", 6},
		{"一", "yī", "一", 6},
		{"二", "èr", "二", 6},
		{"三", "sān", "三", 6},
		{"四", "sì", "四", 6},
		{"五", "wǔ", "五", 6},
		{"六", "liù", "六", 6},
		{"七", "qī", "七", 6},
		{"八", "bā", "八", 6},
		{"九", "jiǔ", "九", 6},
		{"十", "shí", "十", 6},
		{"点钟", "diǎn zhōng", "〜時", 6},
		{"分钟", "fēn zhōng", "分", 6},
		{"今天", "jīn tiān", "今日", 6},
		{"明天", "míng tiān", "明日", 6},

		// 🛒 買い物 (Lesson ID: 7)
		{"商店", "shāng diàn", "店", 7},
		{"超市", "chāo shì", "スーパーマーケット", 7},
		{"市场", "shì chǎng", "市場", 7},
		{"衣服", "yī fu", "服", 7},
		{"裤子", "kù zi", "ズボン", 7},
		{"鞋子", "xié zi", "靴", 7},
		{"帽子", "mào zi", "帽子", 7},
		{"尺寸", "chǐ cùn", "サイズ", 7},
		{"颜色", "yán sè", "色", 7},
		{"试穿", "shì chuān", "試着", 7},
		{"打折", "dǎ zhé", "割引", 7},
		{"信用卡", "xìn yòng kǎ", "クレジットカード", 7},
		{"现金", "xiàn jīn", "現金", 7},
		{"贵", "guì", "高い（値段）", 7},
		{"便宜", "pián yi", "安い（値段）", 7},

		// 🚆 交通 (Lesson ID: 8)
		{"地铁", "dì tiě", "地下鉄", 8},
		{"公交车", "gōng jiāo chē", "バス", 8},
		{"出租车", "chū zū chē", "タクシー", 8},
		{"火车", "huǒ chē", "列車", 8},
		{"飞机", "fēi jī", "飛行機", 8},
		{"自行车", "zì xíng chē", "自転車", 8},
		{"站", "zhàn", "駅", 8},
		{"票", "piào", "切符", 8},
		{"单程票", "dān chéng piào", "片道切符", 8},
		{"往返票", "wǎng fǎn piào", "往復切符", 8},
		{"直行", "zhí xíng", "直進", 8},
		{"左转", "zuǒ zhuǎn", "左折", 8},
		{"右转", "yòu zhuǎn", "右折", 8},
		{"远", "yuǎn", "遠い", 8},
		{"近", "jìn", "近い", 8},
	}

	for _, item := range items {
		_, err := queries.CreateChineseItem(context.Background(), db.CreateChineseItemParams{
			Character: item.character,
			Pinyin:    item.pinyin,
			Meaning:   item.meaning,
			LessonID:  pgtype.Int4{Int32: item.lessonID, Valid: true},
		})
		if err != nil {
			log.Printf("Failed to create item %s: %v", item.character, err)
		}
	}

	// 実用フレーズレッスン
	practiceLessons := []struct {
		title       string
		description string
	}{
		{"🗣️ 実用フレーズ", "日常生活で使える実用的なフレーズ"},
		{"🏥 健康と緊急", "健康や緊急時に役立つ表現"},
		{"🌦️ 天気と気候", "天気や気候に関する表現"},
		{"👨‍👩‍👧‍👦 家族と人間関係", "家族や人間関係に関する表現"},
	}

	// レッスンIDのオフセット
	// lessonIDOffset := 8

	// 追加レッスンの作成
	for _, lesson := range practiceLessons {
		_, err := queries.CreateLesson(context.Background(), db.CreateLessonParams{
			Title:       lesson.title,
			Description: pgtype.Text{String: lesson.description, Valid: true},
		})
		if err != nil {
			log.Printf("Failed to create lesson %s: %v", lesson.title, err)
		}
	}

	// 実用フレーズアイテム
	practicalPhrases := []struct {
		character string
		pinyin    string
		meaning   string
		lessonID  int32
	}{
		// 🗣️ 実用フレーズ (Lesson ID: 9)
		{"能用信用卡吗", "néng yòng xìn yòng kǎ ma", "クレジットカードは使えますか", 9},
		{"这里离远吗", "zhè lǐ lí yuǎn ma", "ここから遠いですか", 9},
		{"能推荐一下吗", "néng tuī jiàn yí xià ma", "おすすめを教えてください", 9},
		{"附近有地铁站吗", "fù jìn yǒu dì tiě zhàn ma", "近くに地下鉄の駅はありますか", 9},
		{"不要太辣", "bú yào tài là", "あまり辛くしないでください", 9},
		{"帮我拍照", "bāng wǒ pāi zhào", "写真を撮ってください", 9},
		{"手机没电了", "shǒu jī méi diàn le", "携帯の電池が切れました", 9},
		{"可以便宜点吗", "kě yǐ pián yi diǎn ma", "もう少し安くできますか", 9},
		{"说慢一点", "shuō màn yì diǎn", "ゆっくり話してください", 9},
		{"能上网吗", "néng shàng wǎng ma", "インターネットに接続できますか", 9},
		{"需要帮忙", "xū yào bāng máng", "助けが必要です", 9},
		{"我想吃饭", "wǒ xiǎng chī fàn", "食事をしたいです", 9},
		{"明天见", "míng tiān jiàn", "また明日", 9},
		{"我晚了", "wǒ wǎn le", "遅れました", 9},
		{"我同意", "wǒ tóng yì", "同意します", 9},

		// 🏥 健康と緊急 (Lesson ID: 10)
		{"我生病了", "wǒ shēng bìng le", "病気です", 10},
		{"头疼", "tóu téng", "頭痛", 10},
		{"肚子疼", "dù zi téng", "お腹が痛い", 10},
		{"发烧", "fā shāo", "熱がある", 10},
		{"感冒", "gǎn mào", "風邪", 10},
		{"需要医生", "xū yào yī shēng", "医者が必要です", 10},
		{"急救", "jí jiù", "救急", 10},
		{"医院在哪里", "yī yuàn zài nǎ lǐ", "病院はどこですか", 10},
		{"打电话给医生", "dǎ diàn huà gěi yī shēng", "医者に電話する", 10},
		{"药店", "yào diàn", "薬局", 10},
		{"过敏", "guò mǐn", "アレルギー", 10},
		{"疼痛", "téng tòng", "痛み", 10},
		{"休息", "xiū xi", "休憩", 10},
		{"受伤", "shòu shāng", "怪我", 10},
		{"呼吸困难", "hū xī kùn nán", "呼吸困難", 10},

		// 🌦️ 天気と気候 (Lesson ID: 11)
		{"天气", "tiān qì", "天気", 11},
		{"晴天", "qíng tiān", "晴れ", 11},
		{"多云", "duō yún", "曇り", 11},
		{"下雨", "xià yǔ", "雨", 11},
		{"下雪", "xià xuě", "雪", 11},
		{"刮风", "guā fēng", "風", 11},
		{"冷", "lěng", "寒い", 11},
		{"热", "rè", "暑い", 11},
		{"凉爽", "liáng shuǎng", "涼しい", 11},
		{"温暖", "wēn nuǎn", "暖かい", 11},
		{"春天", "chūn tiān", "春", 11},
		{"夏天", "xià tiān", "夏", 11},
		{"秋天", "qiū tiān", "秋", 11},
		{"冬天", "dōng tiān", "冬", 11},
		{"台风", "tái fēng", "台風", 11},

		// 👨‍👩‍👧‍👦 家族と人間関係 (Lesson ID: 12)
		{"家", "jiā", "家", 12},
		{"父亲", "fù qīn", "父", 12},
		{"母亲", "mǔ qīn", "母", 12},
		{"兄弟", "xiōng dì", "兄弟", 12},
		{"姐妹", "jiě mèi", "姉妹", 12},
		{"哥哥", "gē ge", "お兄さん", 12},
		{"弟弟", "dì di", "弟", 12},
		{"姐姐", "jiě jie", "お姉さん", 12},
		{"妹妹", "mèi mei", "妹", 12},
		{"儿子", "ér zi", "息子", 12},
		{"女儿", "nǚ ér", "娘", 12},
		{"爷爷", "yé ye", "おじいさん", 12},
		{"奶奶", "nǎi nai", "おばあさん", 12},
		{"朋友", "péng you", "友達", 12},
		{"同学", "tóng xué", "クラスメート", 12},
	}

	// 実用フレーズアイテムの作成
	for _, item := range practicalPhrases {
		_, err := queries.CreateChineseItem(context.Background(), db.CreateChineseItemParams{
			Character: item.character,
			Pinyin:    item.pinyin,
			Meaning:   item.meaning,
			LessonID:  pgtype.Int4{Int32: item.lessonID, Valid: true},
		})
		if err != nil {
			log.Printf("Failed to create item %s: %v", item.character, err)
		}
	}

	log.Println("Seed data created successfully")
}

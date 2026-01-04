const express = require('express');
const session = require('express-session');
const axios = require('axios');
const path = require('path');
const multer  = require('multer');
const mysql = require('mysql2/promise');
const bodyParser = require('body-parser');

const app = express();
const http = require('http');
const { Server } = require('socket.io');
const port = 3000;
const server = http.createServer(app);
const io = new Server(server);
const ACCESS_TOKEN = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';  // アクセストークン
const INSTANCE_URL = 'https://mastodon.social';

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('public'));
app.use('/uploads', express.static('uploads'));
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.json());

app.use(session({
  secret: 'secret-key',
  resave: false,
  saveUninitialized: true,
}));

async function getDb() {
  return await mysql.createConnection({
    host: '127.0.0.1',
    user: 'user',
    password: 'userpwd',
    database: 'sns'
  });
}

// アップロードファイルの保存設定（フォルダやファイル名）
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');  // 保存フォルダ（事前に作成しておく）
  },
  filename: (req, file, cb) => {
    // 元の拡張子を保持してユニークなファイル名にする例
    const ext = path.extname(file.originalname);
    const basename = path.basename(file.originalname, ext);
    cb(null, basename + '-' + Date.now() + ext);
  }
});
const upload = multer({ storage: storage });

// Mastodon API処理
async function postStatus(statusText) {
  try {
    const res = await axios.post(
      `${INSTANCE_URL}/api/v1/statuses`,
      new URLSearchParams({ status: statusText }).toString(),
      {
        headers: {
          'Authorization': `Bearer ${ACCESS_TOKEN}`,
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      }
    );
    console.log('投稿成功:', res.data.url);
  } catch (error) {
    if (error.response) {
      console.error('APIエラー:', error.response.data);
    } else {
      console.error('通信エラー:', error.message);
    }
  }
}

// セッション管理、セッション切れの場合ログイン
function isAuthenticated(req, res, next) {
  if (!req.session.userId) return res.redirect('/login');
  next();
}

// セッションある場合、idとパスワードを入力
app.get('/login', (req, res) => {
  res.render('login', { status: 0, id: req.session.userId || '', pwd: req.session.userPwd || '' });
});

// ログイン画面で入力された内容のチェック
app.post('/login', async (req, res) => {
  const { id, pwd } = req.body;
  const db = await getDb();
  const [rows] = await db.execute('SELECT pwd FROM users WHERE id = ?', [id]);
  if (rows.length && rows[0].pwd === pwd) {
    req.session.userId = id;
    req.session.userPwd = pwd;
    res.redirect('/home');
  } else {
    res.render('login', { status: rows.length ? 2 : 1, id, pwd });
  }
});

//会員登録のget処理
app.get('/registration', (req, res) => {
  res.render('registration', { id: '', errorMsg1: '', errorMsg2: '' });
});

//会員登録処理
app.post('/registration', async (req, res) => {
  const { id, pwd } = req.body;
  const errorMsg1 = (id.length < 4 || id.length > 12) ? '文字数が不適切です' : '';
  const errorMsg2 = (pwd.length < 4 || pwd.length > 12) ? '文字数が不適切です' : '';
  if (errorMsg1 || errorMsg2) {
    return res.render('registration', { errorMsg1, errorMsg2 });
  }
  try {
    const db = await getDb();
    await db.execute('INSERT INTO users (id, pwd, name) VALUES (?, ?, ?)', [id, pwd, id]);
    res.redirect('/login');
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      res.render('registration', { errorMsg1: '既に使われているidです', errorMsg2: '' });
    } else {
      res.status(500).send('エラー：' + err.message);
    }
  }
});

// ホーム画面のget処理、メッセージ、いいね数、いいねしているかどうかを返信
app.get('/home', isAuthenticated, async (req, res) => {
  const db = await getDb();
  const favid = req.session.userId;
  const [messages] = await db.execute(
    `SELECT
      users.id,
      message.time,
      users.name,
      message.message,
      img.path,
      COALESCE(fav_counts.count, 0) AS fav_count
    FROM message
    JOIN users ON message.id = users.id
    LEFT JOIN img ON message.id = img.id AND message.time = img.time
    LEFT JOIN (
      SELECT id, time, COUNT(*) AS count
      FROM fav
      GROUP BY id, time
    ) AS fav_counts ON message.id = fav_counts.id AND message.time = fav_counts.time
    ORDER BY message.time DESC
    LIMIT 10`
  );
  const [fav] = await db.execute("SELECT id, time FROM fav WHERE favid = ?", [favid]);
  res.render('home', { messages, fav, favid });
});

// ポストデータの登録
app.post('/post_data', isAuthenticated, upload.single('image'), async (req, res) => {
  const db = await getDb();
  const timestamp = new Date();
  await db.execute('INSERT INTO message (id, time, message, address) VALUES (?, ?, ?, ?)', [
    req.session.userId,
    timestamp,
    req.body.postMsg,
    'all'
  ]);
  const [name] = await db.execute("SELECT name FROM users WHERE id = ?", [req.session.userId]);
  if (req.file) {
    await db.execute('INSERT INTO img (path, id, time) VALUES (?, ?, ?)', [
      req.file.path,
      req.session.userId,
      timestamp
    ]);
    io.emit('add-post', {  // 全体にポストを通知（画像あり）
      userId: req.session.userId,
      name: name[0].name,
      timestamp: timestamp,
      message: req.body.postMsg,
      path: req.file.path
    });
  } else {
    io.emit('add-post', {  // 全体にポストを通知（画像なし）
      userId: req.session.userId,
      name: name[0].name,
      timestamp: timestamp,
      message: req.body.postMsg,
      path: null
    });
  }
  if (req.body.mastodonFlag == "true") {  // Mastodon連携ポスト
    postStatus(req.body.postMsg);
  }
  res.json({ redirect: '/home' });
});

// いいねをしたときの処理と通知
app.post('/home_fav', isAuthenticated, async (req, res) => {
  const db = await getDb();
  const userId = req.body.userId;
  const time = req.body.time;
  const favid = req.session.userId;

  try {
    const [[row]] = await db.execute(
      'SELECT COUNT(*) AS count FROM fav WHERE id = ? AND time = ? AND favid = ?',
      [userId, time, favid]
    );

    if (row.count > 0) {  // いいね解除
      await db.execute('DELETE FROM fav WHERE id = ? AND time = ? AND favid = ?', [userId, time, favid]);
    } else {  // いいね追加
      await db.execute('INSERT INTO fav (id, time, favid) VALUES (?, ?, ?)', [userId, time, favid]);
      const roomName = `user_${userId}`;
      io.to(roomName).emit('private_message', 'fav');  // いいねされた人に通知
    }

    res.json({ success: true });
  } catch (e) {
    console.error(e);
    res.json({ success: false });
  }
});

// ユーザ情報を返信
app.get('/user_status', isAuthenticated, async (req, res) => {
  const db = await getDb();
  const userId = req.query.id;

  const [[user]] = await db.execute('SELECT name, comment FROM users WHERE id = ?', [userId]);
  const [[followRow]] = await db.execute('SELECT COUNT(*) AS count FROM follow WHERE follow = ? AND followed = ?', [req.session.userId, userId]);
  const isFollow = followRow.count > 0;
  const [followList] = await db.execute('SELECT id, name FROM users WHERE id IN (SELECT followed FROM follow WHERE follow = ?)', [userId]);
  const [followerList] = await db.execute('SELECT id, name FROM users WHERE id IN (SELECT follow FROM follow WHERE followed = ?)', [userId]);
  res.render('user_status', { user, isFollow, followList, followerList });
});

// フォロー・フォロー解除の処理と、フォロー通知
app.post('/user_status', isAuthenticated, async (req, res) => {
  const db = await getDb();
  const followerId = req.session.userId;
  const followedId = req.query.followed;

  try {
    const [[row]] = await db.execute(
      'SELECT COUNT(*) AS count FROM follow WHERE follow = ? AND followed = ?',
      [followerId, followedId]
    );

    if (row.count > 0) {  // フォロー解除
      await db.execute('DELETE FROM follow WHERE follow = ? AND followed = ?', [followerId, followedId]);
    } else {  // フォロー
      await db.execute('INSERT INTO follow (follow, followed) VALUES (?, ?)', [followerId, followedId]);
      const roomName = `user_${followedId}`;
      io.to(roomName).emit('private_message', 'follow');
    }

    res.json({ success: true });
  } catch (e) {
    console.error(e);
    res.json({ success: false });
  }
});

// 特定のユーザに通知するためのルーム作成
io.on('connection', (socket) => {
  socket.on('register', (userId) => {
    const roomName = `user_${userId}`;
    socket.join(roomName);
  });
});

server.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});

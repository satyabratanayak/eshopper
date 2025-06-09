const express = require("express");
const User = require("../models/user");
const bcryptjs = require("bcryptjs");
const authRouter = express.Router();
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth");
const nodemailer = require("nodemailer");

// Temporary in-memory store for OTPs
const otpStore = {}; // Format: { "user@example.com": { otp: "123456", expiresAt: timestamp } }


// SIGN UP
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, password } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }

    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
      email,
      password: hashedPassword,
      name,
    });
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Sign In Route
// Exercise
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .json({ msg: "User with this email does not exist!" });
    }

    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect password." });
    }

    const token = jwt.sign({ id: user._id }, "passwordKey");
    res.json({ token, ...user._doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// get user data
authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(req.user);
  res.json({ ...user._doc, token: req.token });
});

authRouter.post("/api/signup/getotp", async (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ status: false, msg: "Email is required" });
  }

  const otp = Math.floor(100000 + Math.random() * 900000).toString(); // 6-digit OTP
  const expiresAt = Date.now() + 5 * 60 * 1000; // valid for 5 minutes

  otpStore[email] = { otp, expiresAt };

  // Send email
  try {
    const transporter = nodemailer.createTransport({
      service: "gmail",
      auth: {
        user: "satyabratanayak.14038@gmail.com",
        pass: "tqiq ovjq fejw mztk",
      },
    });

    await transporter.sendMail({
      from: '"Eshopper App" contact@eshopper.com',
      to: email,
      subject: "Eshopper Login OTP Code",
      text: `Your OTP code for Eshopper is ${otp}. This OTP will be valid for next 5 min`,
    });

    res.json({ status: true, msg: "OTP sent" });
  } catch (error) {
    console.error("Error sending OTP:", error);
    res.json({ status: false, msg: "OTP not sent" });
  }
});



authRouter.post("/api/signup/verifyotp", async (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) {
    return res.status(400).json({ status: false, msg: "Email and OTP are required" });
  }

  const saved = otpStore[email];

  if (!saved) {
    return res.json({ status: false, msg: "OTP invalid" });
  }

  if (Date.now() > saved.expiresAt) {
    delete otpStore[email];
    return res.json({ status: false, msg: "OTP expired" });
  }

  if (saved.otp !== otp) {
    return res.json({ status: false, msg: "OTP invalid" });
  }

  // delete otpStore[email]; // OTP used
  res.json({ status: true, msg: "OTP valid" });
});


module.exports = authRouter;


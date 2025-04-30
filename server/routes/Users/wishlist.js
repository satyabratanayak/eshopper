const express = require("express");
const wishlistRouter = express.Router();
const auth = require("../../middlewares/auth");
const Order = require("../../models/order");
const { Product } = require("../../models/product");
const User = require("../../models/user");

// 1. Add Product to Wishlist
wishlistRouter.post("/api/wishlist", auth, async (req, res) => {
    try {
        const { productId } = req.body;
        const user = await User.findById(req.user);

        if (!user.wishlist.includes(productId)) {
            user.wishlist.push(productId);
            await user.save();
        }

        res.json(user.wishlist);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// 2. Remove Product from Wishlist
wishlistRouter.delete("/api/wishlist/:id", auth, async (req, res) => {
    try {
        const user = await User.findById(req.user);
        user.wishlist = user.wishlist.filter(
            (itemId) => itemId.toString() !== req.params.id
        );
        await user.save();

        res.json(user.wishlist);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// 3. Get Wishlist Products (Populated)
wishlistRouter.get("/api/wishlist", auth, async (req, res) => {
    try {
        const user = await User.findById(req.user).populate("wishlist");
        res.json(user.wishlist);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// 4. Check if a Product is in Wishlist
wishlistRouter.get("/api/wishlist/has/:id", auth, async (req, res) => {
    try {
        const user = await User.findById(req.user);
        const exists = user.wishlist.includes(req.params.id);
        res.json({ wishlisted: exists });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

module.exports = wishlistRouter;

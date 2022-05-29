/* Le produit qui a été vendu en plus grande quantité durant une étape */
SELECT
    name,
    quantity
FROM
    Sell_Product NATURAL
    JOIN produit
WHERE
    quantity = (
        SELECT
            MAX(quantity)
        FROM
            Sell_Product
    );
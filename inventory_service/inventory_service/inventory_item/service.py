from inventory_service.inventory_item.model import InventoryItem

temp_fake_db = {
    1: InventoryItem(id=1, name="bob's mystery item", quantity=777),
    2: InventoryItem(id=2, name="bob's strange item", quantity=333),
    3: InventoryItem(id=3, name="bob's fine item", quantity=111),
}


def get_inventory_item(id: int) -> InventoryItem:
    return temp_fake_db[id]

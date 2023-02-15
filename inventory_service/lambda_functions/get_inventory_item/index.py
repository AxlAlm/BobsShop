from inventory_service.inventory_item import get_inventory_item
from inventory_service.inventory_item.model import InventoryItem


def lambda_handler(event, context) -> InventoryItem:
    message = "Hello {} !".format(event["key1"])

    print(message)
    return get_inventory_item(id=1)
    # return {"message": message, "ok": True}

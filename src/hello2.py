

def lambda_handler(event, context):
   message = 'Hello 2 {} !'.format(event['key1'])
   return {
       'message' : message,
       'ok': True
   }
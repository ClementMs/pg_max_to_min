# pg_max_to_min
PostgreSQL Aggregate Function to Return the Max and Min values of an Integer Column. 

By default, the function will return the result in the following format : max_value -> min_value. 

To call this function, you need to provide 2 parameters: table_name (TEXT) and column_name (TEXT). 
For instance: 

'''
SELECT 

    max_to_min('test_table', 'test_column')

'''

You can change the format of the result with the optional parameter format_type (TEXT), which accepts the value 'record'. 
For instance:

'''

SELECT 

    max_to_min('test_table', 'test_column', 'record')
    
'''    
    
This query will return the result formatted as following : (max_value, min_value). 

If your integer column does not contain any value, the function will return 

''' 
no value found in column test_column

''' 

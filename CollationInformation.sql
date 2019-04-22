SELECT name,
       COLLATIONPROPERTY(name, 'CodePage') AS Code_Page,
       description
FROM sys.fn_HelpCollations();
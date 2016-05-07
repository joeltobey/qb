component extends='testbox.system.BaseSpec' {
    function run() {
        describe('get methods', function() {
            beforeEach(function() {
                variables.query = new Quick.models.Query.Builder();
                getMockBox().prepareMock(query);

                var utils = new Quick.models.Query.QueryUtils()
                query.$property(propertyName = 'utils', mock = utils);

                var mockWirebox = getMockBox().createStub();
                var mockJoinClause = getMockBox()
                    .prepareMock(new Quick.models.Query.JoinClause('inner', 'second'));
                mockJoinClause.$property(propertyName = 'utils', mock = utils);
                mockWirebox
                    .$('getInstance')
                    .$args(name = 'JoinClause@Quick', initArguments = {
                        type = 'inner',
                        table = 'second'
                    })
                    .$results(mockJoinClause);
                query.$property(propertyName = 'wirebox', mock = mockWirebox);
            });

            it('retreives bindings in a flat array', function() {
                query.join('second', function(join) {
                    join.where('second.locale', '=', 'en-US');
                }).where('first.quantity', '>=', '10');

                expect(query.getBindings()).toBe([{ value = 'en-US', cfsqltype = 'cf_sql_varchar' }, { value = 10, cfsqltype = 'cf_sql_numeric' }]);
            });

            it('retreives a map of bindings', function() {
                query.join('second', function(join) {
                    join.where('second.locale', '=', 'en-US');
                }).where('first.quantity', '>=', '10');

                var bindings = query.getRawBindings();
                
                expect(bindings).toBeStruct();
            });
        });
    }
}
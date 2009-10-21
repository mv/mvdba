
set echo on
set feedback on

-- to be run as SYSTEM
--

create or replace type SYSTEM.string_agg_type as object (
--
-- Ref: http://asktom.oracle.com/pls/asktom/f?p=100:11:3870699020971715::::P11_QUESTION_ID:2196162600402
--
   total varchar2(4000),

   static function
        ODCIAggregateInitialize(sctx IN OUT string_agg_type )
        return number,

   member function
        ODCIAggregateIterate(self IN OUT string_agg_type ,
                             value IN varchar2 )
        return number,

   member function
        ODCIAggregateTerminate(self IN string_agg_type,
                               returnValue OUT  varchar2,
                               flags IN number)
        return number,

   member function
        ODCIAggregateMerge(self IN OUT string_agg_type,
                           ctx2 IN string_agg_type)
        return number
);
/

create or replace type body SYSTEM.string_agg_type is
--
-- Ref: http://asktom.oracle.com/pls/asktom/f?p=100:11:3870699020971715::::P11_QUESTION_ID:2196162600402
--
    static function ODCIAggregateInitialize(sctx IN OUT string_agg_type)
    return number
    is
    begin
        sctx := string_agg_type( null );
        return ODCIConst.Success;
    end;

    member function ODCIAggregateIterate(self IN OUT string_agg_type,
                                         value IN varchar2 )
    return number
    is
    begin
        self.total := self.total || ',' || value;
        return ODCIConst.Success;
    end;

    member function ODCIAggregateTerminate(self IN string_agg_type,
                                           returnValue OUT varchar2,
                                           flags IN number)
    return number
    is
    begin
        returnValue := ltrim(self.total,',');
        return ODCIConst.Success;
    end;

    member function ODCIAggregateMerge(self IN OUT string_agg_type,
                                       ctx2 IN string_agg_type)
    return number
    is
    begin
        self.total := self.total || ctx2.total;
        return ODCIConst.Success;
    end;


end ;
/

CREATE or replace FUNCTION SYSTEM.stragg(input varchar2 ) RETURN varchar2
PARALLEL_ENABLE AGGREGATE
USING string_agg_type;
/

CREATE OR REPLACE PUBLIC SYNONYM stragg FOR system.stragg;
GRANT EXECUTE ON      stragg TO  PUBLIC;



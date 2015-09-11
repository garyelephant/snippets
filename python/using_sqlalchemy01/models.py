from sqlalchemy import create_engine, exc
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, Boolean, Enum
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import NullPool

"""
disable connection pool for the following reason:
(1) TimeoutError: QueuePool limit of size 5 overflow 10 reached, connection timed out, timeout 30
"""
#class LookLively( object ):
#    """Ensures that MySQL connections checked out of the pool are alive."""
#
#    def checkout( self, dbapi_con, con_record, con_proxy ):
#        try:
#            try:
#                dbapi_con.ping( False )
#            except TypeError:
#                dbapi_con.ping()
#        except dbapi_con.OperationalError, ex:
#            if ex.args[ 0 ] in ( 2006, 2013, 2014, 2045, 2055 ):
#                raise exc.DisconnectionError()
#            else:
#                raise
#
#
#engine = create_engine( 'mysql+pymysql://<user_name>:<password>@<mysql_ser_host>/<database_name>', echo=False, echo_pool="debug", pool_recycle=1800, listeners=[ 
LookLively() ] )

engine = create_engine( 'mysql+pymysql://<user_name>:<password>@<mysql_ser_host>/<database_name>', echo=False, poolclass=NullPool )

Session = sessionmaker( bind=engine )

Base = declarative_base()

class User( Base ):
    __tablename__ = 'user'

    id = Column( Integer, primary_key=True )
    name = Column( String( 32 ) )
    email = Column( String( 64 ) )
    # extension number
    ext_num = Column( String( 16 ) )
    cellphone = Column( String( 11 ) )
    passwd = Column( String( 32 ) )
    product = Column( String( 128 ) )

    def __repr__( self ):
        return "<User(name='%s', passwd='%s', product='%s')>" % ( self.name, self.passwd, self.product )
        
if __name__ == '__main__':
    # python models.py
    # create table
    Base.metadata.create_all( engine )

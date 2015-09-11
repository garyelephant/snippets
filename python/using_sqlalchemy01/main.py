from .models import User
from .database import session_scope

if __name__ == '__main__':
    with session_scope() as session:
        users = session.query( User ).order_by( User.id )
        
        # Remove all object instances from this Session to make them available to accessed by outside
        users.expunge_all()
        
    for u in users:
        print u

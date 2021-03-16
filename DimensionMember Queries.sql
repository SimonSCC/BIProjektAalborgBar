SELECT Member.id, Member.active, Member.[year], SemesterGroups.periode, SemesterGroups.semester FROM Member
INNER JOIN SemesterGroups ON Member.id=SemesterGroups.member_id;

SELECT * FROM Member

SELECT * FROM SemesterGroups

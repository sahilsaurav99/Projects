import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { PermissionsGuard } from '../auth/guards/permissions.guard';
import { RequirePermissions } from '../auth/decorators/permissions.decorator';
import { FacultyService } from './faculty.service';
import { CreateFacultyDto } from './dto/create-faculty.dto';
import { ListFacultyQueryDto } from './dto/list-faculty.query';
import { UpdateFacultyDto } from './dto/update-faculty.dto';

/**
 * FacultyController
 *
 * Permission keys mirror the students module:
 *   faculty.read   | faculty.create | faculty.update
 *   faculty.delete | faculty.restore
 */
@ApiTags('Faculty')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller({ path: 'faculty', version: '1' })
export class FacultyController {
  constructor(private readonly faculty: FacultyService) {}

  @Get()
  @RequirePermissions('faculty.read')
  @ApiOperation({ summary: 'List faculty (paginated, filterable).' })
  @ApiOkResponse({ description: 'Paginated list of faculty.' })
  list(@Query() query: ListFacultyQueryDto) {
    return this.faculty.findAll(query);
  }

  @Get(':id')
  @RequirePermissions('faculty.read')
  @ApiOperation({ summary: 'Get a single faculty member by id.' })
  findOne(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.faculty.findOne(id);
  }

  @Post()
  @RequirePermissions('faculty.create')
  @ApiOperation({
    summary: 'Create a new faculty member under a department/school.',
  })
  create(@Body() dto: CreateFacultyDto) {
    return this.faculty.create(dto);
  }

  @Patch(':id')
  @RequirePermissions('faculty.update')
  @ApiOperation({ summary: 'Update a faculty member (partial).' })
  update(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateFacultyDto,
  ) {
    return this.faculty.update(id, dto);
  }

  @Delete(':id')
  @RequirePermissions('faculty.delete')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary:
      'Soft-delete a faculty member (sets deletedAt, status=RESIGNED).',
  })
  remove(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.faculty.remove(id);
  }

  @Post(':id/restore')
  @RequirePermissions('faculty.restore')
  @ApiOperation({ summary: 'Restore a previously soft-deleted faculty member.' })
  restore(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.faculty.restore(id);
  }
}
